module UI.SelectMenu exposing (Msg(..), State, UpdaterConfig, init, update, updateState, view)

import Data.App exposing (responsive)
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input
import Html.Attributes
import Html.Events
import Json.Decode as Decode
import RemoteData exposing (RemoteData(..))
import UI.Icon exposing (checkIcon)



-- CONFIG


type alias SelectMenuConfig value msg =
    { title : String
    , description : String
    , defaultText : String
    , options : Maybe (List value)
    , toString : value -> String
    , showFilter : Bool
    , model : State value
    , device : Device
    , toMsg : Msg value -> msg
    }


type alias UpdaterConfig value model msg =
    { changeSelected : Maybe (Maybe value -> msg)
    , changeFilter : Maybe (String -> msg)
    , getter : model -> State value
    , setter : model -> State value -> model
    , update : msg -> model -> ( model, Cmd msg )
    }



-- MODEL


type alias State value =
    { open : Bool
    , selected : Maybe value
    , filter : String
    , visibleOptions : List value
    }


init : Maybe value -> State value
init maybeValue =
    { open = False
    , selected = maybeValue
    , filter = ""
    , visibleOptions = []
    }



-- MESSAGE


type Msg value
    = NoOp
    | SetOpen Bool
    | SetSelected (Maybe value)
    | SetFilter String



-- UPDATE


updateState : UpdaterConfig value model msg -> Msg value -> model -> ( model, Cmd msg )
updateState ({ getter, setter } as config) subMsg model =
    let
        ( selectMenuState, msgs ) =
            update
                config
                subMsg
                (getter model)

        foldMsgs msgAct ( modelAcc, cmdAcc ) =
            let
                ( newModelAct, newCmdAct ) =
                    config.update msgAct modelAcc
            in
            ( newModelAct
            , Cmd.batch [ cmdAcc, newCmdAct ]
            )

        ( newModel, newCmds ) =
            msgs
                |> List.foldl foldMsgs ( model, Cmd.none )
    in
    ( setter newModel selectMenuState
    , newCmds
    )


update : UpdaterConfig value model msg -> Msg value -> State value -> ( State value, List msg )
update config msg model =
    case msg of
        NoOp ->
            ( model, [] )

        SetOpen newOpen ->
            let
                newFilter =
                    if newOpen then
                        model.filter

                    else
                        ""

                msgs =
                    Maybe.withDefault [] (Maybe.map (\f -> [ f newFilter ]) config.changeFilter)
            in
            ( { model
                | open = newOpen
                , filter = newFilter
              }
            , msgs
            )

        SetSelected newSelected ->
            let
                msgs =
                    Maybe.withDefault [] (Maybe.map (\f -> [ f "" ]) config.changeFilter)
                        ++ Maybe.withDefault [] (Maybe.map (\f -> [ f newSelected ]) config.changeSelected)
            in
            ( { model | selected = newSelected, open = False, filter = "" }
            , msgs
            )

        SetFilter filter ->
            let
                msgs =
                    Maybe.withDefault [] (Maybe.map (\f -> [ f filter ]) config.changeFilter)
            in
            ( { model | filter = filter }, msgs )



-- VIEW


view : List (Attribute msg) -> SelectMenuConfig value msg -> Element msg
view attrs ({ title, defaultText, toString, model, toMsg, device } as config) =
    let
        openAttrs =
            if model.open then
                [ responsive device
                    { desktop = below (listDropdownBody config)
                    , phone = below (listDropdownBody config)
                    }
                    |> Element.mapAttribute toMsg
                ]

            else
                []
    in
    Input.button
        ([ pointer
         , focused [ Border.color <| rgba255 0 0 0 1 ]
         , mapAttribute toMsg onBlur
         ]
            ++ openAttrs
            ++ attrs
        )
        { onPress = Nothing
        , label =
            row
                [ spacing 4
                , Font.size 14
                , Font.color <| rgb255 88 96 105
                , mouseOver
                    [ Font.color <| rgb255 36 41 46 ]
                , Events.onClick (toMsg <| SetOpen True)
                ]
                [ el
                    []
                    (text title)
                , el
                    [ Font.semiBold
                    ]
                    (model.selected
                        |> Maybe.map toString
                        |> Maybe.withDefault defaultText
                        |> text
                    )
                , text "▾"
                ]
        }


listDropdownBody : SelectMenuConfig value msg -> Element (Msg value)
listDropdownBody { description, options, toString, model, showFilter, device } =
    let
        listTitle =
            el
                [ dropdownGroup
                , tabIndex -1
                , width fill
                , height <| px 34
                , padding 8
                , Font.semiBold
                , Background.color <| rgb255 0xF6 0xF8 0xFA
                ]
                (el [ centerY ] <| text description)

        filterBox =
            el
                [ width fill
                , padding 10
                , Background.color <| rgb255 0xF6 0xF8 0xFA
                , Border.color <| rgb255 0xDF 0xE2 0xE5
                , Border.widthEach
                    { left = 0
                    , right = 0
                    , top = 1
                    , bottom = 1
                    }
                ]
            <|
                Input.search
                    [ onBlur
                    , dropdownGroup
                    , padding 8
                    , height <| px 32
                    , tabIndex 0
                    , Font.size 14
                    , Border.color <| rgb255 0xDF 0xE2 0xE5
                    , Border.width 1
                    , Border.innerShadow
                        { offset = ( 0, 1 )
                        , size = 0
                        , blur = 1
                        , color = rgba255 27 31 35 0.075
                        }
                    ]
                    { text = model.filter
                    , placeholder = Just <| Input.placeholder [ centerY, height fill ] (text "Filter languages")
                    , label = Input.labelHidden "Filter languages"
                    , onChange = SetFilter
                    }

        selectedAttrs value =
            case model.selected of
                Nothing ->
                    []

                Just selected ->
                    if selected /= value then
                        []

                    else
                        [ Font.bold
                        , Font.color <| rgb255 0x00 0x00 0x00
                        , inFront <|
                            el
                                [ centerY
                                , padding 8
                                , Font.color <| rgb255 255 0 0
                                ]
                                (checkIcon [])
                        ]

        itemButton index value =
            el
                ([ dropdownGroup
                 , tabIndex (index + 1)
                 , width fill
                 , height <| px 34
                 , paddingEach { left = 30, right = 8, top = 8, bottom = 8 }
                 , pointer
                 , Font.color <| rgb255 0x58 0x60 0x69
                 , Border.color <| rgb255 0xEA 0xEC 0xEF
                 , Border.widthEach
                    { left = 0
                    , right = 0
                    , top = 1
                    , bottom = 0
                    }
                 , Events.onFocus <|
                    if model.selected == Just value then
                        NoOp

                    else
                        SetSelected (Just value)
                 , mouseOver
                    [ Font.color <| rgb255 0xFF 0xFF 0xFF
                    , Background.color <| rgb255 0x03 0x66 0xD6
                    ]
                 ]
                    ++ selectedAttrs value
                )
            <|
                el
                    [ centerY ]
                    (text <| toString value)
    in
    el
        [ responsive device
            { desktop = paddingEach { top = 8, bottom = 8, left = 12, right = 0 }
            , phone = moveLeft 12
            }
        , responsive device
            { desktop = Element.alignRight
            , phone = Element.alignLeft
            }
        ]
    <|
        column
            [ width <| px 300
            , Font.size 12
            , Border.color <| rgba255 27 31 35 0.15
            , Border.width 1
            , Border.rounded 3
            , Border.shadow
                { offset = ( 0, 3 )
                , size = 0
                , blur = 12
                , color = rgba255 27 31 35 0.15
                }
            ]
            [ listTitle
            , if showFilter then
                filterBox

              else
                Element.none
            , column
                [ width fill
                , height <| maximum 400 fill
                , scrollbarY
                , Background.color <| rgb255 0xFF 0xFF 0xFF
                ]
                (options
                    |> Maybe.withDefault []
                    |> List.filter (toString >> String.toLower >> String.contains (String.toLower model.filter))
                    |> List.indexedMap itemButton
                )
            ]


dropdownGroup : Attribute msg
dropdownGroup =
    attribute referenceDataName "filterBox"


referenceDataName : String
referenceDataName =
    "data-focus-group"


onBlur : Attribute (Msg value)
onBlur =
    let
        -- relatedTarget only works if element has tabindex
        dataDecoder =
            Decode.at [ "relatedTarget", "attributes", referenceDataName, "value" ] Decode.string

        attrToMsg attr =
            if attr == "filterBox" then
                NoOp

            else
                SetOpen False

        blurDecoder =
            Decode.maybe dataDecoder
                |> Decode.map (Maybe.map attrToMsg)
                |> Decode.map (Maybe.withDefault <| SetOpen False)
    in
    Html.Events.on "blur" blurDecoder
        |> htmlAttribute


attribute : String -> String -> Attribute msg
attribute name value =
    Html.Attributes.attribute name value
        |> htmlAttribute


tabIndex : Int -> Attribute msg
tabIndex index =
    Html.Attributes.tabindex index
        |> htmlAttribute

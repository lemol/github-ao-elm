-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Github.Enum.GistPrivacy exposing (..)

import Json.Decode as Decode exposing (Decoder)


{-| The privacy of a Gist

  - All - Gists that are public and secret
  - Public - Public
  - Secret - Secret

-}
type GistPrivacy
    = All
    | Public
    | Secret


list : List GistPrivacy
list =
    [ All, Public, Secret ]


decoder : Decoder GistPrivacy
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "ALL" ->
                        Decode.succeed All

                    "PUBLIC" ->
                        Decode.succeed Public

                    "SECRET" ->
                        Decode.succeed Secret

                    _ ->
                        Decode.fail ("Invalid GistPrivacy type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representating the Enum to a string that the GraphQL server will recognize.
-}
toString : GistPrivacy -> String
toString enum =
    case enum of
        All ->
            "ALL"

        Public ->
            "PUBLIC"

        Secret ->
            "SECRET"


{-| Convert from a String representation to an elm representation enum.
This is the inverse of the Enum `toString` function. So you can call `toString` and then convert back `fromString` safely.

    Swapi.Enum.Episode.NewHope
        |> Swapi.Enum.Episode.toString
        |> Swapi.Enum.Episode.fromString
        == Just NewHope

This can be useful for generating Strings to use for <select> menus to check which item was selected.

-}
fromString : String -> Maybe GistPrivacy
fromString enumString =
    case enumString of
        "ALL" ->
            Just All

        "PUBLIC" ->
            Just Public

        "SECRET" ->
            Just Secret

        _ ->
            Nothing
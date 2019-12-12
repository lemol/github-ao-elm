-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Github.Enum.RepositoryOrderField exposing (..)

import Json.Decode as Decode exposing (Decoder)


{-| Properties by which repository connections can be ordered.

  - CreatedAt - Order repositories by creation time
  - Name - Order repositories by name
  - PushedAt - Order repositories by push time
  - Stargazers - Order repositories by number of stargazers
  - UpdatedAt - Order repositories by update time

-}
type RepositoryOrderField
    = CreatedAt
    | Name
    | PushedAt
    | Stargazers
    | UpdatedAt


list : List RepositoryOrderField
list =
    [ CreatedAt, Name, PushedAt, Stargazers, UpdatedAt ]


decoder : Decoder RepositoryOrderField
decoder =
    Decode.string
        |> Decode.andThen
            (\string ->
                case string of
                    "CREATED_AT" ->
                        Decode.succeed CreatedAt

                    "NAME" ->
                        Decode.succeed Name

                    "PUSHED_AT" ->
                        Decode.succeed PushedAt

                    "STARGAZERS" ->
                        Decode.succeed Stargazers

                    "UPDATED_AT" ->
                        Decode.succeed UpdatedAt

                    _ ->
                        Decode.fail ("Invalid RepositoryOrderField type, " ++ string ++ " try re-running the @dillonkearns/elm-graphql CLI ")
            )


{-| Convert from the union type representating the Enum to a string that the GraphQL server will recognize.
-}
toString : RepositoryOrderField -> String
toString enum =
    case enum of
        CreatedAt ->
            "CREATED_AT"

        Name ->
            "NAME"

        PushedAt ->
            "PUSHED_AT"

        Stargazers ->
            "STARGAZERS"

        UpdatedAt ->
            "UPDATED_AT"


{-| Convert from a String representation to an elm representation enum.
This is the inverse of the Enum `toString` function. So you can call `toString` and then convert back `fromString` safely.

    Swapi.Enum.Episode.NewHope
        |> Swapi.Enum.Episode.toString
        |> Swapi.Enum.Episode.fromString
        == Just NewHope

This can be useful for generating Strings to use for <select> menus to check which item was selected.

-}
fromString : String -> Maybe RepositoryOrderField
fromString enumString =
    case enumString of
        "CREATED_AT" ->
            Just CreatedAt

        "NAME" ->
            Just Name

        "PUSHED_AT" ->
            Just PushedAt

        "STARGAZERS" ->
            Just Stargazers

        "UPDATED_AT" ->
            Just UpdatedAt

        _ ->
            Nothing
-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Github.Object.EnterpriseServerUserAccountEmail exposing (..)

import Github.InputObject
import Github.Interface
import Github.Object
import Github.Scalar
import Github.ScalarCodecs
import Github.Union
import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode


{-| Identifies the date and time when the object was created.
-}
createdAt : SelectionSet Github.ScalarCodecs.DateTime Github.Object.EnterpriseServerUserAccountEmail
createdAt =
    Object.selectionForField "ScalarCodecs.DateTime" "createdAt" [] (Github.ScalarCodecs.codecs |> Github.Scalar.unwrapCodecs |> .codecDateTime |> .decoder)


{-| The email address.
-}
email : SelectionSet String Github.Object.EnterpriseServerUserAccountEmail
email =
    Object.selectionForField "String" "email" [] Decode.string


{-| -}
id : SelectionSet Github.ScalarCodecs.Id Github.Object.EnterpriseServerUserAccountEmail
id =
    Object.selectionForField "ScalarCodecs.Id" "id" [] (Github.ScalarCodecs.codecs |> Github.Scalar.unwrapCodecs |> .codecId |> .decoder)


{-| Indicates whether this is the primary email of the associated user account.
-}
isPrimary : SelectionSet Bool Github.Object.EnterpriseServerUserAccountEmail
isPrimary =
    Object.selectionForField "Bool" "isPrimary" [] Decode.bool


{-| Identifies the date and time when the object was last updated.
-}
updatedAt : SelectionSet Github.ScalarCodecs.DateTime Github.Object.EnterpriseServerUserAccountEmail
updatedAt =
    Object.selectionForField "ScalarCodecs.DateTime" "updatedAt" [] (Github.ScalarCodecs.codecs |> Github.Scalar.unwrapCodecs |> .codecDateTime |> .decoder)


{-| The user account to which the email belongs.
-}
userAccount : SelectionSet decodesTo Github.Object.EnterpriseServerUserAccount -> SelectionSet decodesTo Github.Object.EnterpriseServerUserAccountEmail
userAccount object_ =
    Object.selectionForCompositeField "userAccount" [] object_ identity
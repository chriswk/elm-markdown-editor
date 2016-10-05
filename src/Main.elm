module Main exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Markdown exposing (..)
import Material
import Material.Scheme
import Material.Options exposing (css)
import Material.Textfield as Textfield


type alias Model =
    { inputText : String
    , mdl : Material.Model
    }


type Msg
    = NoOp
    | Change String
    | Mdl (Material.Msg Msg)


inputArea : Model -> Html Msg
inputArea model =
    Textfield.render Mdl [0] model.mdl
        [ Textfield.label "Documentation"
        , Textfield.floatingLabel
        , Textfield.value model.inputText
        , Textfield.rows 32
        , Textfield.cols 80
        , Textfield.textarea
        , Textfield.onInput Change ]


previewArea : Model -> Html Msg
previewArea model =
    let
        formattedMarkdown =
            toMarkdown model.inputText
    in
        div [ class "content" ]
            [ formattedMarkdown
            ]


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ inputArea model
        , previewArea model
        ]
        |> Material.Scheme.top


markdownOptions : Options
markdownOptions =
    { githubFlavored = Just { tables = True, breaks = True }
    , sanitize = True
    , smartypants = True
    , defaultHighlighting = Nothing
    }


toMarkdown : String -> Html Msg
toMarkdown userInput =
    Markdown.toHtmlWith markdownOptions [] userInput


model : Model
model =
    { inputText = ""
    , mdl = Material.model
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        Change newContent ->
            { model | inputText = newContent } ! []

        Mdl msg' ->
            Material.update msg' model


main : Program Never
main =
    App.program { init = ( model, Cmd.none ), view = view, update = update, subscriptions = always Sub.none }


type alias Mdl =
    Material.Model

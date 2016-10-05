module Main exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Markdown exposing (..)


type alias Model =
    { inputText : String
    }


type Msg
    = NoOp
    | Change String


inputArea : Html Msg
inputArea =
    div []
        [ textarea [ placeholder "Text to parse to markdown", onInput Change, rows 8, cols 80 ] []
        ]


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
        [ inputArea
        , previewArea model
        ]


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
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        Change newContent ->
            { model | inputText = newContent }


main : Program Never
main =
    App.beginnerProgram { model = model, view = view, update = update }

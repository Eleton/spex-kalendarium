-- Read more about this program in the official Elm guide:
-- https://guide.elm-lang.org/architecture/effects/http.html

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode



main =
  Html.program
    { init = init "Kårspexkalendarium"
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { topic : String
  , data : Test
  }

type alias Test =
  { num : Int
  , string : String
  }

startTest = Test 3 "lol"

init : String -> (Model, Cmd Msg)
init topic =
  ( Model topic startTest
  , fetch
  )



-- UPDATE


type Msg
  = Data (Result Http.Error String)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Data (Ok data) ->
      Debug.log (toString data)
      (model, Cmd.none)

    Data (Err _) ->
      (model, Cmd.none)



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h2 [] [text model.topic]
    , div [] [text model.data.string]
    ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- HTTP

fetch : Cmd Msg
fetch =
  Http.send Data (Http.get "/test.json" decodeData)

decodeData : Decode.Decoder String
decodeData =
  Decode.at ["string"] Decode.string
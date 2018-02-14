-- Read more about this program in the official Elm guide:
-- https://guide.elm-lang.org/architecture/effects/http.html

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import Date



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
  , data : Spex
  , kalendarium : List Spex
  }

type alias Test =
  { num : Int
  , string : String
  }

type alias Event =
  { event_name : String
  , date : String --Date.Date
  --, end_date : Maybe Date.Date
  , category : String
  }

type alias Spex =
  { spex : String
  , or : String
  , year : Int
  , events : List Event
  }

startTest = Spex "g3" "svår" 2010 []

init : String -> (Model, Cmd Msg)
init topic =
  ( Model topic startTest []
  , fetch
  )



-- UPDATE


type Msg
  = Data (Result Http.Error Spex)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Data (Ok data) ->
      Debug.log (toString data)
      --(Model model.topic data model.kalendarium, Cmd.none)
      ({model | data = data}, Cmd.none)

    Data (Err message) ->
      Debug.log (toString message)
      (model, Cmd.none)



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h2 [] [text model.topic]
    , div [] [text (toString model.data)]
    ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- HTTP

fetch : Cmd Msg
fetch =
  Http.send Data (Http.get "/spexkalendarium.json" decodeData)

decodeData : Decode.Decoder Spex
decodeData =
  --Maybe.map2 Test (Decode.field "num" Decode.int) (Decode.field "string" Decode.string)
  decode Spex
    |> Json.Decode.Pipeline.required "spex" Decode.string
    |> Json.Decode.Pipeline.required "or" Decode.string
    |> Json.Decode.Pipeline.required "year" Decode.int
    |> Json.Decode.Pipeline.required "events" (Decode.list
      (
        decode Event
        |> Json.Decode.Pipeline.required "event_name" Decode.string
        |> Json.Decode.Pipeline.required "date" Decode.string
        |> Json.Decode.Pipeline.required "category" Decode.string
      )
    )
    


module Index exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as Decode

type alias Model =
  { trend : String }
init : (Model, Cmd Msg)
init =
  (Model "safari", Cmd.none)

type Msg
  = TrendyProducts
  | MoreProducts (Result Http.Error Metadata)
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    TrendyProducts ->
      (model, getTrendyProducts model.trend)

    MoreProducts (Ok newTrend) ->
      ({ model | trend = newTrend }, Cmd.none)

    MoreProducts (Err _) ->
      (model, Cmd.none)

getTrendyProducts : Http.Request Metadata
getTrendyProducts =
  Http.get "https://calm-beach-60805.herokuapp.com/" decodeMetadata

type alias Metadata =
  { clickUrl : String
  , brandedName : String
  , price : String
  , salePrice : String
  }

decodeMetadata : Decode.Decoder Metadata
decodeMetadata =
  Decode.map4 Metadata
    (Decode.field "clickUrl" Decode.string)
    (Decode.field "brandedName" Decode.string)
    (Decode.field "price" Decode.string)
    (Decode.field "salePrice" Decode.string)

send : Cmd Msg
send =
  Http.send MoreProducts Metadata




view : Model -> Html Msg
view model =
  div [ class "slim centered" ]
    [ div [ class "right-align" ]
      [ a [ href "https://github.com/alexshook/fashion_barbarian" ] [ text "about" ]
      , h1 [ class "centered" ] [ text "Fashion Barbarian" ]
      , div [ id "products" ] []
      , node "script" [ id "template", type_ "text/x-handlebars-template" ]
          [ div [ class "grid" ]
              [ text "{{#each products}}"
              , div [ class "grid-item" ]
                  [ img [ attribute "height" "{{image.sizes.Large.actualHeight}}", src "{{image.sizes.Large.url}}" ]
                      []
                  , div [ class "name" ]
                      [ a [ href "{{clickUrl}}" ]
                          [ text "{{brandedName}}" ]
                      ]
                  , div [ class "price" ]
                      [ text "{{#if salePrice}} ${{salePrice}} on sale, originally{{/if}} ${{price}}" ]
                  ]
              , text "{{/each}}"
              ]
          ]
      ]
    ]

--main =
--  view "dummy model"

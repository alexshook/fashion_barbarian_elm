module Index exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as Decode

main =
  Html.program
    { init = init "safari"
    , view = view
    , update = update
    }


-- MODEL


type alias Model =
  { trend : String
  , products : String Product
  }

init : (Model, Cmd Msg)
init trend =
  (Model trend getMoreProducts, Cmd.none)

type alias Product =
  { brandedName : String
  , clickUrl : String
  , price : String
  , salePrice : String
  , imageUrl : String
  , imageHeight : Int
  }


-- UPDATE


type Msg = 
  TrendyProducts
  | GetProducts (Result Http.Error String)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    TrendyProducts ->
      (model, getMoreProducts model.trend)

    GetProducts (Ok newProducts) ->
      ( { model | products = newProducts}, Cmd.none)

    GetProducts (Err _) ->
      (model, Cmd.none)


-- VIEW


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


-- HTTP


getMoreProducts : String -> Cmd Msg
getMoreProducts trend =
  let
    url =
      "https://calm-beach-60805.herokuapp.com/"
  in
    Http.send GetProducts (Http.get url productDecoder)

productDecoder =
  Decode.map6
    Product
      (Decode.at [ "brandedName" ] Decode.string)
      (Decode.at [ "clickUrl" ] Decode.string)
      (Decode.at [ "price" ] Decode.string)
      (Decode.at [ "salePrice" ] Decode.string)
      (Decode.at [ "imageUrl" ] Decode.string)
      (Decode.at [ "imageHeight" ] Decode.int)

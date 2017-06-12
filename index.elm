module Index exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

view model =
  div [ class "slim centered" ]
    [ div [ class "right-align" ]
      [ a [ href "https://github.com/alexshook/fashion_barbarian" ] [ text "about" ]
      , h1 [ class "centered" ] [ text "Fashion Barbarian" ]
      , div [ id "products" ] []
      , node "script" [ id "template", type_ "text/x-handlebars-template" ]
          [ div [ class "grid" ]
              [ text "{{#each products}}        "
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
              , text "{{/each}}      "
              ]
          ]
      ]
    ]

main =
  view "dummy model"
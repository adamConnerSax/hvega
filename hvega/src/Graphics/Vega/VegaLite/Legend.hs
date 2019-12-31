{-# LANGUAGE OverloadedStrings #-}

{-|
Module      : Graphics.Vega.VegaLite.Legend
Copyright   : (c) Douglas Burke, 2018-2019
License     : BSD3

Maintainer  : dburke.gw@gmail.com
Stability   : unstable
Portability : OverloadedStrings

Types for legends.

-}

module Graphics.Vega.VegaLite.Legend
       ( LegendType(..)
       , LegendOrientation(..)
       , LegendLayout(..)
       , BaseLegendLayout(..)
       , LegendProperty(..)
       , LegendValues(..)

         -- not for external export
       , legendProperty
       , legendOrientLabel
       , legendLayoutSpec

       ) where

import qualified Data.Aeson as A
import qualified Data.Text as T

import Data.Aeson ((.=), object, toJSON)

import Graphics.Vega.VegaLite.Foundation
  ( APosition
  , Bounds
  , Color
  , CompositionAlignment
  , FontWeight
  , HAlign
  , Opacity
  , Orientation
  , OverlapStrategy
  , Side
  , Symbol
  , VAlign
  , ZIndex
  , anchorLabel
  , boundsSpec
  , compositionAlignmentSpec
  , fontWeightSpec
  , hAlignLabel
  , orientationSpec
  , overlapStrategyLabel
  , sideLabel
  , symbolLabel
  , vAlignLabel

  , fromT
  )
import Graphics.Vega.VegaLite.Specification (VLSpec, LabelledSpec)
import Graphics.Vega.VegaLite.Time
  ( DateTime
  , dateTimeProperty
  )


-- | Indicates the type of legend to create. It is used with 'LType'.
--
--   Prior to version @0.4.0.0.0@ this was called @Legend@ and the
--   constructors did not end in @Legend@.
--
data LegendType
    = GradientLegend
      -- ^ Typically used for continuous quantitative data.
    | SymbolLegend
      -- ^ Typically used for categorical data.


legendLabel :: LegendType -> T.Text
legendLabel GradientLegend = "gradient"
legendLabel SymbolLegend = "symbol"


{-|

Indicates the legend orientation. See the
<https://vega.github.io/vega-lite/docs/legend.html#config Vega-Lite documentation>
for more details.

-}

-- based on schema 3.3.0 #/definitions/LegendOrient

data LegendOrientation
  = LONone
  | LOLeft
  | LORight
  | LOTop
  -- ^ @since 0.4.0.0
  | LOBottom
  -- ^ @since 0.4.0.0
  | LOTopLeft
  | LOTopRight
  | LOBottomLeft
  | LOBottomRight


legendOrientLabel :: LegendOrientation -> T.Text
legendOrientLabel LONone = "none"
legendOrientLabel LOLeft = "left"
legendOrientLabel LORight = "right"
legendOrientLabel LOTop = "top"
legendOrientLabel LOBottom = "bottom"
legendOrientLabel LOTopLeft = "top-left"
legendOrientLabel LOTopRight = "top-right"
legendOrientLabel LOBottomLeft = "bottom-left"
legendOrientLabel LOBottomRight = "bottom-right"


{- |

/Highly experimental/ and used with 'Graphics.Vega.VegaLite.LeLayout'.

@since 0.4.0.0

-}

-- based on schema 3.3.0 #/definitions/LegendLayout

-- TODO: support SignalRef?

data LegendLayout
  = LeLAnchor APosition
    -- ^ The anchor point for legend orient group layout.
  | LeLBottom [BaseLegendLayout]
  | LeLBottomLeft [BaseLegendLayout]
  | LeLBottomRight [BaseLegendLayout]
  | LeLBounds Bounds
    -- ^ The bounds calculation to use for legend orient group layout.
  | LeLCenter Bool
    -- ^ A flag to center legends within a shared orient group.
  | LeLDirection Orientation
    -- ^ The layout firection for legend orient group layout.
  | LeLLeft [BaseLegendLayout]
  | LeLMargin Double
    -- ^ The margin, in pixels, between legends within an orient group.
  | LeLOffset Double
    -- ^ The offset, in pixels, from the chart body for a legend orient group.
  | LeLRight [BaseLegendLayout]
  | LeLTop [BaseLegendLayout]
  | LeLTopLeft [BaseLegendLayout]
  | LeLTopRight [BaseLegendLayout]


legendLayoutSpec :: LegendLayout -> LabelledSpec
legendLayoutSpec (LeLAnchor anc) = "anchor" .= anchorLabel anc
legendLayoutSpec (LeLBottom bl) = "bottom" .= toBLSpec bl
legendLayoutSpec (LeLBottomLeft bl) = "bottom-left" .= toBLSpec bl
legendLayoutSpec (LeLBottomRight bl) = "bottom-right" .= toBLSpec bl
legendLayoutSpec (LeLBounds bnds) = "bounds" .= boundsSpec bnds
legendLayoutSpec (LeLCenter b) = "center" .= b
legendLayoutSpec (LeLDirection o) = "direction" .= orientationSpec o
legendLayoutSpec (LeLLeft bl) = "left" .= toBLSpec bl
legendLayoutSpec (LeLMargin x) = "margin" .= x
legendLayoutSpec (LeLOffset x) = "offset" .= x
legendLayoutSpec (LeLRight bl) = "right" .= toBLSpec bl
legendLayoutSpec (LeLTop bl) = "top" .= toBLSpec bl
legendLayoutSpec (LeLTopLeft bl) = "top-left" .= toBLSpec bl
legendLayoutSpec (LeLTopRight bl) = "top-right" .= toBLSpec bl


{- |

/Highly experimental/ and used with constructors from 'LegendLayout'.

@since 0.4.0.0

-}

-- based on schema 3.3.0 #/definitions/BaseLegendLayout

data BaseLegendLayout
  = BLeLAnchor APosition
    -- ^ The anchor point for legend orient group layout.
  | BLeLBounds Bounds
    -- ^ The bounds calculation to use for legend orient group layout.
  | BLeLCenter Bool
    -- ^ A flag to center legends within a shared orient group.
  | BLeLDirection Orientation
    -- ^ The layout direction for legend orient group layout.
  | BLeLMargin Double
    -- ^ The margin, in pixels, between legends within an orient group.
  | BLeLOffset Double
    -- ^ The offset, in pixels, from the chart body for a legend orient group.


toBLSpec :: [BaseLegendLayout] -> VLSpec
toBLSpec = object . map baseLegendLayoutSpec

baseLegendLayoutSpec :: BaseLegendLayout -> LabelledSpec
baseLegendLayoutSpec (BLeLAnchor anc) = "anchor" .= anchorLabel anc
baseLegendLayoutSpec (BLeLBounds bnds) = "bounds" .= boundsSpec bnds
baseLegendLayoutSpec (BLeLCenter b) = "center" .= b
baseLegendLayoutSpec (BLeLDirection o) = "direction" .= orientationSpec o
baseLegendLayoutSpec (BLeLMargin x) = "margin" .= x
baseLegendLayoutSpec (BLeLOffset x) = "offset" .= x


{-|

Legend properties, set with 'Graphics.Vega.VegaLite.MLegend'. For more detail see the
<https://vega.github.io/vega-lite/docs/legend.html#legend-properties Vega-Lite documentation>.

The @LEntryPadding@ constructor was removed in @0.4.0.0@.

-}

data LegendProperty
    = LClipHeight Double
      -- ^ The height, in pixels, to clip symbol legend entries.
      --
      --   @since 0.4.0.0
    | LColumnPadding Double
      -- ^ The horizontal padding, in pixels, between symbol legend entries.
      --
      --   @since 0.4.0.0
    | LColumns Int
      -- ^ The number of columns in which to arrange symbol legend entries.
      --   A value of @0@ or lower indicates a single row with one column per entry.
      --
      --   @since 0.4.0.0
    | LCornerRadius Double
      -- ^ The corner radius for the full legend.
      --
      --   @since 0.4.0.0
    | LDirection Orientation
      -- ^ The direction of the legend.
      --
      --   @since 0.4.0.0
    | LFillColor Color
      -- ^ The background fill color for the full legend.
      --
      --   @since 0.4.0.0
    | LFormat T.Text
      -- ^ [Formatting pattern](https://vega.github.io/vega-lite/docs/format.html) for
      --   legend values. To distinguish between formatting as numeric values
      --   and data/time values, additionally use 'LFormatAsNum' or 'LFormatAsTemporal'.
    | LFormatAsNum
      -- ^ Legends should be formatted as numbers. Use a
      --   [d3 numeric format string](https://github.com/d3/d3-format#locale_format)
      --   with 'LFormat'.
      --
      -- @since 0.4.0.0
    | LFormatAsTemporal
      -- ^ Legends should be formatted as dates or times. Use a
      --   [d3 date/time format string](https://github.com/d3/d3-time-format#locale_format)
      --   with 'LFormat'.
      --
      -- @since 0.4.0.0
    | LGradientLength Double
      -- ^ The length in pixels of the primary axis of the color gradient.
      --
      --   @since 0.4.0.0
    | LGradientOpacity Opacity
      -- ^ The opacity of the color gradient.
      --
      --   @since 0.4.0.0
    | LGradientStrokeColor Color
      -- ^ The color of the gradient stroke.
      --
      --   @since 0.4.0.0
    | LGradientStrokeWidth Double
      -- ^ The width, in pixels, of the gradient stroke.
      --
      --   @since 0.4.0.0
    | LGradientThickness Double
      -- ^ The thickness, in pixels, of the color gradient.
      --
      --   @since 0.4.0.0
    | LGridAlign CompositionAlignment
      -- ^ The [grid layout](https://vega.github.io/vega/docs/layout) for
      --   the symbol legends.
      --
      --   @since 0.4.0.0
    | LLabelAlign HAlign
      -- ^ @since 0.4.0.0
    | LLabelBaseline VAlign
      -- ^ @since 0.4.0.0
    | LLabelColor Color
      -- ^ @since 0.4.0.0
    | LLabelFont T.Text
      -- ^ @since 0.4.0.0
    | LLabelFontSize Double
      -- ^ @since 0.4.0.0
    | LLabelFontStyle T.Text
      -- ^ @since 0.4.0.0
    | LLabelFontWeight FontWeight
      -- ^ @since 0.4.0.0
    | LLabelLimit Double
      -- ^ @since 0.4.0.0
    | LLabelOffset Double
      -- ^ @since 0.4.0.0
    | LLabelOpacity Opacity
      -- ^ @since 0.4.0.0
    | LLabelOverlap OverlapStrategy
      -- ^ @since 0.4.0.0
    | LLabelPadding Double
      -- ^ @since 0.4.0.0
    | LLabelSeparation Double
      -- ^ @since 0.4.0.0
    | LOffset Double
      -- ^ The offset in pixels by which to displace the legend from
      --   the data rectangle and axes.
    | LOrient LegendOrientation
      -- ^ The legend orientation.
    | LPadding Double
      -- ^ The padding, in pixels, between the border and content of
      --   the legend group.
    | LRowPadding Double
      -- ^ The vertical padding, in pixels, between symbol legend entries.
      --
      --   @since 0.4.0.0
    | LStrokeColor Color
      -- ^ The border stroke color for the full legend.
      --
      --   @since 0.4.0.0
    | LSymbolDash [Double]
      -- ^ The dash style for symbols (alternating stroke, space lengths
      --   in pixels).
      --
      --   @since 0.4.0.0
    | LSymbolDashOffset Double
      -- ^ The pixel offset at which to start drawing the symbol dash array.
      --
      --   @since 0.4.0.0
    | LSymbolFillColor Color
      -- ^ The fill color of the legend symbol.
      --
      --   @since 0.4.0.0
    | LSymbolOffset Double
      -- ^ The horizontal pixel offset for legend symbols.
      --
      --   @since 0.4.0.0
    | LSymbolOpacity Opacity
      -- ^ The opacity of the legend symbols.
      --
      --   @since 0.4.0.0
    | LSymbolSize Double
      -- ^ The size of the legend symbol, in pixels.
      --
      --   @since 0.4.0.0
    | LSymbolStrokeColor Color
      -- ^ The edge color of the legend symbol.
      --
      --   @since 0.4.0.0
    | LSymbolStrokeWidth Double
      -- ^ The width of the sumbol's stroke.
      --
      --   @since 0.4.0.0
    | LSymbolType Symbol
      -- ^ @since 0.4.0.0
    | LTickCount Double
      -- ^ The desired number of tick values for quantitative legends.
    | LTickMinStep Double
      -- ^ The minimum desired step between legend ticks, in terms of the scale
      --   domain values.
      --
      --   @since 0.4.0.0
    | LTitle T.Text
    | LNoTitle
      -- ^ Draw no title.
      --
      -- @since 0.4.0.0
    | LTitleAlign HAlign
      -- ^ @since 0.4.0.0
    | LTitleAnchor APosition
      -- ^ @since 0.4.0.0
    | LTitleBaseline VAlign
      -- ^ @since 0.4.0.0
    | LTitleColor Color
      -- ^ @since 0.4.0.0
    | LTitleFont T.Text
      -- ^ @since 0.4.0.0
    | LTitleFontSize Double
      -- ^ @since 0.4.0.0
    | LTitleFontStyle T.Text
      -- ^ @since 0.4.0.0
    | LTitleFontWeight FontWeight
      -- ^ @since 0.4.0.0
    | LTitleLimit Double
      -- ^ The maximum allowed pixel width of the legend title.
      --
      --   @since 0.4.0.0
    | LTitleOpacity Opacity
      -- ^ Opacity of the legend title.
      --
      --   @since 0.4.0.0
    | LTitleOrient Side
      -- ^ Orientation of the legend title.
      --
      --   @since 0.4.0.0
    | LTitlePadding Double
      -- ^ The padding, in pixels, between title and legend.
      --
      --   @since 0.4.0.0
    | LType LegendType
      -- ^ The type of the legend.
    | LValues LegendValues
      -- ^ Explicitly set the visible legend values.
    | LeX Double
      -- ^ Custom x position, in pixels, for the legend when 'LOrient' is set to 'LONone'.
      --
      --   @since 0.4.0.0
    | LeY Double
      -- ^ Custom y position, in pixels, for the legend when 'LOrient' is set to 'LONone'.
      --
      --   @since 0.4.0.0
    | LZIndex ZIndex
      -- ^ The z-index at which to draw the legend.

legendProperty :: LegendProperty -> LabelledSpec
legendProperty (LClipHeight x) = "clipHeight" .= x
legendProperty (LColumnPadding x) = "columnPadding" .= x
legendProperty (LColumns n) = "columns" .= n
legendProperty (LCornerRadius x) = "cornerRadius" .= x
legendProperty (LDirection o) = "direction" .= orientationSpec o
legendProperty (LFillColor s) = "fillColor" .= s
legendProperty (LFormat s) = "format" .= s
legendProperty LFormatAsNum = "formatType" .= fromT "number"
legendProperty LFormatAsTemporal = "formatType" .= fromT "time"
legendProperty (LGradientLength x) = "gradientLength" .= x
legendProperty (LGradientOpacity x) = "gradientOpacity" .= x
legendProperty (LGradientStrokeColor s) = "gradientStrokeColor" .= s
legendProperty (LGradientStrokeWidth x) = "gradientStrokeWidth" .= x
legendProperty (LGradientThickness x) = "gradientThickness" .= x
legendProperty (LGridAlign ga) = "gridAlign" .= compositionAlignmentSpec ga
legendProperty (LLabelAlign ha) = "labelAlign" .= hAlignLabel ha
legendProperty (LLabelBaseline va) = "labelBaseline" .= vAlignLabel va
legendProperty (LLabelColor s) = "labelColor" .= s
legendProperty (LLabelFont s) = "labelFont" .= s
legendProperty (LLabelFontSize x) = "labelFontSize" .= x
legendProperty (LLabelFontStyle s) = "labelFontStyle" .= s
legendProperty (LLabelFontWeight fw) = "labelFontWeight" .= fontWeightSpec fw
legendProperty (LLabelLimit x) = "labelLimit" .= x
legendProperty (LLabelOffset x) = "labelOffset" .= x
legendProperty (LLabelOpacity x) = "labelOpacity" .= x
legendProperty (LLabelOverlap strat) = "labelOverlap" .= overlapStrategyLabel strat
legendProperty (LLabelPadding x) = "labelPadding" .= x
legendProperty (LLabelSeparation x) = "labelSeparation" .= x
legendProperty (LOffset x) = "offset" .= x
legendProperty (LOrient orl) = "orient" .= legendOrientLabel orl
legendProperty (LPadding x) = "padding" .= x
legendProperty (LRowPadding x) = "rowPadding" .= x
legendProperty (LStrokeColor s) = "strokeColor" .= s

legendProperty (LSymbolDash ds) = "symbolDash" .= ds
legendProperty (LSymbolDashOffset x) = "symbolDashOffset" .= x
legendProperty (LSymbolFillColor s) = "symbolFillColor" .= s
legendProperty (LSymbolOffset x) = "symbolOffset" .= x
legendProperty (LSymbolOpacity x) = "symbolOpacity" .= x
legendProperty (LSymbolSize x) = "symbolSize" .= x
legendProperty (LSymbolStrokeColor s) = "symbolStrokeColor" .= s
legendProperty (LSymbolStrokeWidth x) = "symbolStrikeWidth" .= x
legendProperty (LSymbolType sym) = "symbolType" .= symbolLabel sym
legendProperty (LTickCount x) = "tickCount" .= x
legendProperty (LTickMinStep x) = "tickMinStep" .= x
legendProperty (LTitle s) = "title" .= s
legendProperty LNoTitle = "title" .= A.Null
legendProperty (LTitleAlign ha) = "titleAlign" .= hAlignLabel ha
legendProperty (LTitleAnchor anc) = "titleAnchor" .= anchorLabel anc
legendProperty (LTitleBaseline va) = "titleBaseline" .= vAlignLabel va
legendProperty (LTitleColor s) = "titleColor" .= s
legendProperty (LTitleFont s) = "titleFont" .= s
legendProperty (LTitleFontSize x) = "titleFontSize" .= x
legendProperty (LTitleFontStyle s) = "titleFontStyle" .= s
legendProperty (LTitleFontWeight fw) = "titleFontWeight" .= fontWeightSpec fw
legendProperty (LTitleLimit x) = "titleLimit" .= x
legendProperty (LTitleOpacity x) = "titleOpacity" .= x
legendProperty (LTitleOrient orient) = "titleOrient" .= sideLabel orient
legendProperty (LTitlePadding x) = "titlePadding" .= x
legendProperty (LType lType) = "type" .= legendLabel lType
legendProperty (LValues vals) =
  let ls = case vals of
        LNumbers xs    -> map toJSON xs
        LDateTimes dts -> map (object . map dateTimeProperty) dts
        LStrings ss    -> map toJSON ss
  in "values" .= ls
legendProperty (LeX x) = "legendX" .= x
legendProperty (LeY x) = "legendY" .= x
legendProperty (LZIndex z) = "zindex" .= z


-- | A list of data values suitable for setting legend values, used with
--   'LValues'.


data LegendValues
    = LDateTimes [[DateTime]]
    | LNumbers [Double]
    | LStrings [T.Text]

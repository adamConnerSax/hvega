{-|
Module      : Graphics.Vega.VegaLite
Copyright   : (c) Douglas Burke, 2018-2019
License     : BSD3

Maintainer  : dburke.gw@gmail.com
Stability   : unstable
Portability : CPP, OverloadedStrings, TupleSections

This is a port of the
<http://package.elm-lang.org/packages/gicentre/elm-vegalite/latest Elm Vega Lite module>,
written by Jo Wood of the giCentre at the City
University of London. It was originally based on version @2.2.1@ but
it has been updated to match later versions.  This module allows users
to create a Vega-Lite specification, targeting __version 3__ of the
<https://vega.github.io/schema/vega-lite/v3.json JSON schema>.  The
ihaskell-hvega module provides an easy way to embed Vega-Lite
visualizations in an IHaskell notebook (using
<https://vega.github.io/vega-lite/usage/embed.html Vega-Embed>).

Although this is based on the Elm module, there are differences, such
as using type constructors rather than functions for many properties -
such as @'VL.PName' \"HorsePower\"@ rather than @pName \"HorsePower\"@ -
and the return value of 'VL.toVegaLite'. The intention is to keep close
to the Elm module, but it is more a guide than an absolute
requirement!

Please see "Graphics.Vega.Tutorials.VegaLite" for an introduction
to using @hvega@ to create visualizations.

== Example

Note that this module exports several symbols that are exported
by the Prelude, such as 'VL.filter', 'VL.lookup',
and 'VL.repeat'; to avoid name clashes it's therefore advised
to either import the module qualified, for example:

@
import qualified Graphics.Vega.VegaLite as VL
@

or to hide the clashing names explicitly:

@
import Prelude hiding (filter, lookup, repeat)
@

In the following example, we'll assume the latter.

Let's say we have the following plot declaration in a module:

@
\{\-\# language OverloadedStrings \#\-\}

vl1 =
  let desc = "A very exciting bar chart"

      dat = 'VL.dataFromRows' ['VL.Parse' [("start", 'VL.FoDate' "%Y-%m-%d")]]
            . 'VL.dataRow' [("start", 'VL.Str' "2011-03-25"), ("count", 'VL.Number' 23)]
            . 'VL.dataRow' [("start", 'VL.Dtr' "2011-04-02"), ("count", 'VL.Number' 45)]
            . 'VL.dataRow' [("start", 'VL.Str' "2011-04-12"), ("count", 'VL.Number' 3)]

      barOpts = ['VL.MOpacity' 0.4, 'VL.MColor' "teal"]

      enc = 'VL.encoding'
            . 'VL.position' 'VL.X' ['VL.PName' "start", 'VL.PmType' 'VL.Temporal', 'VL.PAxis' ['VL.AxTitle' "Inception date"]]
            . 'VL.position' 'VL.Y' ['VL.PName' "count", 'VL.PmType' 'VL.Quantitative']

  in 'VL.toVegaLite' ['VL.description' desc, 'VL.background' "white"
                , dat [], 'VL.mark' 'VL.Bar' barOpts, enc []]
@

We can inspect how the encoded JSON looks like in an GHCi session:

@
> 'A.encode' $ 'VL.fromVL' vl1
> "{\"mark\":{\"color\":\"teal\",\"opacity\":0.4,\"type\":\"bar\"},\"data\":{\"values\":[{\"start\":\"2011-03-25\",\"count\":23},{\"start\":\"2011-04-02\",\"count\":45},{\"start\":\"2011-04-12\",\"count\":3}],\"format\":{\"parse\":{\"start\":\"date:'%Y-%m-%d'\"}}},\"$schema\":\"https:\/\/vega.github.io\/schema\/vega-lite\/v3.json\",\"encoding\":{\"x\":{\"field\":\"start\",\"type\":\"temporal\",\"axis\":{\"title\":\"Inception date\"}},\"y\":{\"field\":\"count\",\"type\":\"quantitative\"}},\"background\":\"white\",\"description\":\"A very exciting bar chart\"}"
@

The produced JSON can then be processed with vega-lite, which renders the following image:

<<images/example.png>>

which can also be
<https://vega.github.io/editor/#/url/vega-lite/N4KABGBEC2CGBOBrSAuMxIGMD2Abb8qUALgKay6QA0U2ADrJgJbECeRADAHQAsNkbOqSKQARgkgBfKuCgATWMVhFQECJABuFAK6kAzkQDastekh6l8YiIBMHAIz2AtBwDMTmwFZqUHNoB21mg2rtImahgWCEFQdo4uPC42PljYATE8nmGmEJGWMZBxzhyJ9sn8foFEoeEAujKmkABmBHAxGAzwesJoedEiCmQoAOQApACaTqPQU3LDUpKy2VAAJHqYABakcCIbxMR0eigA9McapADmsFwXLBvaolxM2MfrW3Bnl7BOuCykZ64uAArPTYfzUWSQUj+HByJj+C4qcKQAAeSJyUCaTFIuDkIiiVghGIErCEIjI0DoBAoRJykFgKKYBl6AhYuB6UAAkjDSHRiM9-GBBsJFqZlup2CysTi8WhUukUoIOZAAI7aWCBFiKJjnKRLBpQcSYRAXeBpfyyqAAdw2f1pkDk+kw8CYfIFIgAgmBzvBWGBSCjmPyEWBxPAwJt+gbUv4sYjeotJEA displayed in the Vega Editor>.

Output can be achieved in a Jupyter Lab session with the @vlShow@ function,
provided by @ihaskell-vega@, or 'VL.toHtmlFile' can be used to write out a page of
HTML that includes pointer to JavaScript files which will display a Vega-Lite
specification (there are also functions which provide more control over
the embedding).

-}

module Graphics.Vega.VegaLite
       (
         -- * Creating a Vega-Lite Specification

         VL.toVegaLite
       , VL.toVegaLiteSchema
       , VL.vlSchema2, VL.vlSchema3, VL.vlSchema4, VL.vlSchema
       , VL.fromVL
       , VL.VLProperty(..)
       , VL.VLSpec
       , VL.VegaLite
       , VL.PropertySpec
       , VL.LabelledSpec
       , VL.BuildLabelledSpecs
       , VL.Angle
       , VL.Color
       , VL.Opacity
       , VL.ZIndex
       , VL.combineSpecs
       , VL.toHtml
       , VL.toHtmlFile
       , VL.toHtmlWith
       , VL.toHtmlFileWith

         -- * Creating the Data Specification
         --
         -- $dataspec

       , VL.dataFromUrl
       , VL.dataFromColumns
       , VL.dataFromRows
       , VL.dataFromJson
       , VL.dataFromSource
       , VL.dataName
       , VL.datasets
       , VL.dataColumn
       , VL.dataRow
       , VL.noData
       , VL.Data
       , VL.DataColumn
       , VL.DataRow

         -- ** Geographic Data

       , VL.geometry
       , VL.geoFeatureCollection
       , VL.geometryCollection
       , VL.Geometry(..)

       -- ** Data Generators
       --
       -- $datagen

       , VL.dataSequence
       , VL.dataSequenceAs
       , VL.sphere
       , VL.graticule
       , VL.GraticuleProperty(..)

       -- ** Formatting Input Data
       --
       -- $dataformat

       , VL.Format(..)
       , VL.DataType(..)

         -- * Creating the Transform Specification
         --
         -- $transform

       , VL.transform

         -- ** Map Projections
         --
         -- $projections

       , VL.projection
       , VL.ProjectionProperty(..)
       , VL.Projection(..)
       , VL.ClipRect(..)

         -- ** Aggregation
         --
         -- $aggregation

       , VL.aggregate
       , VL.joinAggregate
       , VL.opAs
       , VL.timeUnitAs
       , VL.Operation(..)

         -- ** Binning
         --
         -- $binning

       , VL.binAs
       , VL.BinProperty(..)

         -- ** Stacking
         --
         -- $stacking

       , VL.stack
       , VL.StackProperty(..)
       , VL.StackOffset(..)

         -- ** Data Calculation
         --
         -- $calculate

       , VL.calculateAs

         -- ** Filtering
         --
         -- $filtering

       , VL.filter
       , VL.Filter(..)
       , VL.FilterRange(..)

         -- ** Flattening
         --
         -- $flattening

       , VL.flatten
       , VL.flattenAs
       , VL.fold
       , VL.foldAs

         -- ** Relational Joining (lookup)
         --
         -- $joining

       , VL.lookup
       , VL.lookupAs

         -- ** Data Imputation
         --
         -- $imputation

       , VL.impute
       , VL.ImputeProperty(..)
       , VL.ImMethod(..)

         -- ** Data sampling
         --
         -- $sampling

       , VL.sample

         -- ** Window Transformations
         --
         -- $window

       , VL.window
       , VL.Window(..)
       , VL.WOperation(..)
       , VL.WindowProperty(..)

         -- * Creating the Mark Specification
         --
         -- $markspec

       , VL.mark
       , VL.Mark(..)

         -- ** Mark properties
         --
         -- $markproperties

       , VL.MarkProperty(..)
       , VL.StrokeCap(..)
       , VL.StrokeJoin(..)

         -- *** Used by Mark Properties

       , VL.Orientation(..)
       , VL.MarkInterpolation(..)
       , VL.Symbol(..)
       , VL.PointMarker(..)
       , VL.LineMarker(..)
       , VL.MarkErrorExtent(..)
       , VL.TooltipContent(..)

         -- ** Cursors
         --
         -- $cursors

       , VL.Cursor(..)

         -- * Creating the Encoding Specification
         --
         -- $encoding

       , VL.encoding
       , VL.Measurement(..)

         -- ** Position Channels
         --
         -- $position

       , VL.position
       , VL.Position(..)

         -- *** Position channel properties

       , VL.PositionChannel(..)

         -- ** Sorting properties
         --
         -- $sortprops

       , VL.SortProperty(..)
       , VL.SortField(..)

         -- ** Axis properties
         --
         -- $axisprops

       , VL.AxisProperty(..)

         -- ** Positioning Constants
         --
         -- *** Text Alignment

       , VL.HAlign(..)
       , VL.VAlign(..)

         -- *** Overlapping text

       , VL.OverlapStrategy(..)

         -- *** Legends

       , VL.Side(..)

         -- ** Mark channels
         --
         -- $markprops

       , VL.size
       , VL.color
       , VL.fill
       , VL.stroke
       , VL.strokeWidth
       , VL.opacity
       , VL.fillOpacity
       , VL.strokeOpacity
       , VL.shape

         -- *** Mark Channel properties

       , VL.MarkChannel(..)

         -- *** Mark Legends
         --
         -- $marklegends

       , VL.LegendType(..)
       , VL.LegendProperty(..)
       , VL.LegendOrientation(..)
       , VL.LegendValues(..)

         -- ** Text Channels
         --
         -- $textchannels

       , VL.text
       , VL.tooltip
       , VL.tooltips
       , VL.TextChannel(..)
       , VL.FontWeight(..)

         -- ** Hyperlink Channels
         --
         -- $hyperlink

       , VL.hyperlink
       , VL.HyperlinkChannel(..)

         -- ** Order Channel
         --
         -- $order

       , VL.order
       , VL.OrderChannel(..)

         -- ** Facet Channel
         --
         -- $facet

       , VL.row
       , VL.column

         -- ** Level of detail Channel
         --
         -- $detail

       , VL.detail
       , VL.DetailChannel(..)

         -- ** Scaling
         --
         -- $scaling

       , VL.ScaleProperty(..)
       , VL.Scale(..)
       , VL.categoricalDomainMap
       , VL.domainRangeMap
       , VL.ScaleDomain(..)
       , VL.ScaleRange(..)
       , VL.ScaleNice(..)

         -- *** Color scaling
         --
         -- $color

       , VL.CInterpolate(..)

         -- * Creating view compositions
         --
         -- $view

       , VL.layer
       , VL.vlConcat
       , VL.columns
       , VL.hConcat
       , VL.vConcat
       , VL.align
       , VL.alignRC
       , VL.spacing
       , VL.spacingRC
       , VL.center
       , VL.centerRC
       , VL.bounds
       , VL.Bounds(..)
       , VL.CompositionAlignment(..)

         -- ** Resolution
         --
         -- $resolution

       , VL.resolve
       , VL.resolution
       , VL.Resolve(..)
       , VL.Channel(..)
       , VL.Resolution(..)

         -- ** Faceted views
         --
         -- $facetview

       , VL.repeat
       , VL.repeatFlow
       , VL.RepeatFields(..)
       , VL.facet
       , VL.facetFlow
       , VL.FacetMapping(..)
       , VL.FacetChannel(..)
       , VL.asSpec
       , VL.specification
       , VL.Arrangement(..)

         -- *** Facet Headers
         --
         -- $facetheaders

       , VL.HeaderProperty(..)

         -- * Creating Selections for Interaction
         --
         -- $selections

       , VL.selection
       , VL.select
       , VL.Selection(..)
       , VL.SelectionProperty(..)
       , VL.Binding(..)
       , VL.InputProperty(..)
       , VL.SelectionMarkProperty(..)

       -- ** Selection Resolution
       --
       -- $selectionresolution

       , VL.SelectionResolution(..)

         -- ** Making conditional channel encodings
         --
         -- $conditional

       , VL.BooleanOp(..)

         -- ** Top-level Settings
         --
         -- $toplevel

       , VL.name
       , VL.description
       , VL.height
       , VL.width
       , VL.padding
       , VL.autosize
       , VL.background
       , VL.usermetadata
       , VL.Padding(..)
       , VL.Autosize(..)

         -- *** Title
         --
         -- $title

       , VL.title

         -- *** View Backgroud
         --
         -- $viewbackground

       , VL.viewBackground
       , VL.ViewBackground(..)

         -- ** Style Setting

       , VL.configure
       , VL.configuration
       , VL.ConfigurationProperty(..)

         -- ** Axis Configuration Options
         --
         -- $axisconfig

       , VL.AxisConfig(..)

         -- ** Legend Configuration Options
         --

       , VL.LegendConfig(..)
       , VL.LegendLayout(..)
       , VL.BaseLegendLayout(..)

         -- ** Scale Configuration Options
         --
         -- $scaleconfig

       , VL.ScaleConfig(..)

         -- ** Scale Range Configuration Options
         --
         -- $scalerangeconfig

       , VL.RangeConfig(..)

         -- ** Title Configuration Options
         --
         -- $titleconfig

       , VL.TitleConfig(..)
       , VL.TitleFrame(..)

         -- ** View Configuration Options
         --
         -- $viewconfig

       , VL.ViewConfig(..)
       , VL.APosition(..)
       , VL.FieldTitleProperty(..)

         -- ** Facet Configuration Options
         --
         -- $facetconfig

       , VL.FacetConfig(..)

         -- ** Concatenated View Configuration Options
         --
         -- $concatconfig

       , VL.ConcatConfig(..)

         -- * General Data types
         --
         -- $generaldatatypes

       , VL.DataValue(..)
       , VL.DataValues(..)

         -- ** Temporal data
         --
         -- $temporaldata

       , VL.DateTime(..)
       , VL.MonthName(..)
       , VL.DayName(..)
       , VL.TimeUnit(..)

         -- * Update notes
         --
         -- $update

         -- ** Version 0.4
         --
         -- $update0400

        )
    where

-- VegaLite redefined several prelude functions, such as filter and
-- repeat, so hide the prelude so the documentation links work.
--
import Prelude ()

-- There has been some attempt to separate out the types based
-- on functionality, but it is somewhat hap-hazard. Most of
-- the fuctionality is in the Core and Foundation modules
-- (ie they are the ones that could perhaps be further split up).
--
import qualified Graphics.Vega.VegaLite.Configuration as VL
import qualified Graphics.Vega.VegaLite.Core as VL
import qualified Graphics.Vega.VegaLite.Data as VL
import qualified Graphics.Vega.VegaLite.Foundation as VL
import qualified Graphics.Vega.VegaLite.Geometry as VL
import qualified Graphics.Vega.VegaLite.Input as VL
import qualified Graphics.Vega.VegaLite.Legend as VL
import qualified Graphics.Vega.VegaLite.Mark as VL
import qualified Graphics.Vega.VegaLite.Output as VL
import qualified Graphics.Vega.VegaLite.Scale as VL
import qualified Graphics.Vega.VegaLite.Selection as VL
import qualified Graphics.Vega.VegaLite.Specification as VL
import qualified Graphics.Vega.VegaLite.Time as VL
import qualified Graphics.Vega.VegaLite.Transform as VL


-- Documentation

-- $dataspec
-- Functions and types for declaring the input data to the
-- visualization. See the
-- [Vega-Lite documentation](https://vega.github.io/vega-lite/docs/data.html#format).

-- $datagen
-- Functions that create new data sources.

-- $dataformat
-- See the Vega-Lite
-- [format](https://vega.github.io/vega-lite/docs/data.html#format) and
-- [JSON](https://vega.github.io/vega-lite/docs/data.html#json) documentation.

-- $transform
-- Functions and types for declaring the transformation rules that
-- are applied to data fields or geospatial coordinates before they
-- are encoded visually.

-- $projections
-- See the
-- [Vega-Lite map projection documentation](https://vega.github.io/vega-lite/docs/projection.html).

-- $aggregation
-- See the
-- [Vega-Lite aggregate documentation](https://vega.github.io/vega-lite/docs/aggregate.html).

-- $binning
-- See the
-- [Vega-Lite binning documentation](https://vega.github.io/vega-lite/docs/bin.html).

-- $stacking
-- See the [Vega-Lite stack documentation](https://vega.github.io/vega-lite/docs/stack.html).

-- $calculate
-- See the
-- [Vega-Lite calculate documentation](https://vega.github.io/vega-lite/docs/calculate.html).

-- $filtering
-- See the
-- [Vega-Lite filter documentation](https://vega.github.io/vega-lite/docs/filter.html).

-- $flattening
-- See the Vega-Lite [flatten](https://vega.github.io/vega-lite/docs/flatten.html)
-- and [fold](https://vega.github.io/vega-lite/docs/fold.html)
-- documentation.

-- $joining
-- See the
-- [Vega-Lite lookup documentation](https://vega.github.io/vega-lite/docs/lookup.html).

-- $imputation
-- Impute missing data. See the
-- [Vega-Lite impute documentation](https://vega.github.io/vega-lite/docs/impute.html#transform).

-- $sampling
-- See the [Vega-Lite sample documentation](https://vega.github.io/vega-lite/docs/sample.html)

-- $window
-- See the Vega-Lite
-- [window transform field](https://vega.github.io/vega-lite/docs/window.html#field-def)
-- and
-- [window transform](https://vega.github.io/vega-lite/docs/window.html#window-transform-definition)
-- documentation.

-- $markspec
-- Types and functions for declaring the type of visual
-- marks used in the visualization.

-- $markproperties
-- See the Vega-Lite
-- [general mark](https://vega.github.io/vega-lite/docs/mark.html#general-mark-properties),
-- [area mark](https://vega.github.io/vega-lite/docs/area.html#properties),
-- [bar mark](https://vega.github.io/vega-lite/docs/bar.html#properties),
-- [boxplot](https://vega.github.io/vega-lite/docs/boxplot.html#properties),
-- [circle mark](https://vega.github.io/vega-lite/docs/circle.html#properties),
-- [error band](https://vega.github.io/vega-lite/docs/errorband.html#properties),
-- [error bar](https://vega.github.io/vega-lite/docs/errorbar.html#properties),
-- [hyperlink mark](https://vega.github.io/vega-lite/docs/mark.html#hyperlink),
-- [line mark](https://vega.github.io/vega-lite/docs/line.html#properties),
-- [point mark](https://vega.github.io/vega-lite/docs/point.html#properties),
-- [square mark](https://vega.github.io/vega-lite/docs/square.html#properties),
-- [text mark](https://vega.github.io/vega-lite/docs/text.html#properties) and
-- [tick mark](https://vega.github.io/vega-lite/docs/tick.html#properties)
-- property documentation.

-- $cursors
-- See the
-- [CSS cursor documentation](https://developer.mozilla.org/en-US/docs/Web/CSS/cursor#Keyword%20values)

-- $encoding
-- Types and functions for declaring which data fields are mapped to which
-- channels. Channels can include: position on screen (e.g. 'VL.X', 'VL.Y'); visual
-- mark properties ('VL.color', 'VL.size', 'VL.stroke', 'VL.shape'); 'VL.text'; 'VL.hyperlink';
-- ordering ('VL.order'); level of 'VL.detail'; and facets for composed
-- visualizations ('VL.facet'). All can be further customised via a series of
-- properties that determine how the encoding is implemented (such as
-- scaling, sorting, and spacing).

-- $position
-- Control where items appear in the visualization. See the
-- [Vega-Lite position documentation](https://vega.github.io/vega-lite/docs/encoding.html#position).

-- $sortprops
-- See the
-- [Vega-Lite sort documentation](https://vega.github.io/vega-lite/docs/sort.html).

-- $axisprops
-- See the
-- Vega-Lite axis property documentation](https://vega.github.io/vega-lite/docs/axis.html#axis-properties).

-- $markprops
-- Control the appearance of the visual marks in the visualization
-- (e.g. 'VL.color' and 'VL.size').

-- $marklegends
-- See the
-- [Vega-Lite legend property documentation](https://vega.github.io/vega-lite/docs/legend.html#legend-properties).

-- $textchannels
-- Control the appearance of the text and tooltip elements in the visualization.

-- $hyperlink
-- Channels which offer a clickable URL destination. Unlike most other
-- channels, the hyperlink channel has no direct visual expression other than the
-- option of changing the cursor style when hovering, so an encoding will usually
-- pair hyperlinks with other visual channels such as marks or texts.

-- $order
-- Channels that relate to the order of data fields such as for sorting stacking order
-- or order of data points in a connected scatterplot. See the
-- <https://vega.github.io/vega-lite/docs/encoding.html#order Vega-Lite documentation>
-- for further details.

-- $facet
-- Channels for faceting single plots into small multiples. Can be used to create
-- trellis plots or other arrangements in rows and columns. See the
-- <https://vega.github.io/vega-lite/docs/encoding.html#facet Vega-Lite documentation>
-- for further details. See also, <#facetview faceted views> for a more flexible (but
-- more verbose) way of defining faceted views.

-- $detail
-- Used for grouping data but without changing the visual appearance of a mark. When,
-- for example, a field is encoded by color, all data items with the same value for
-- that field are given the same color. When a detail channel encodes a field, all
-- data items with the same value are placed in the same group. This allows, for example
-- a line chart with multiple lines to be created – one for each group. See the
-- <https://vega.github.io/vega-lite/docs/encoding.html#detail Vega-Lite documentation>
-- for more information.

-- $scaling
-- Used to specify how the encoding of a data field should be applied. See the
-- [Vega-Lite scale documentation](https://vega.github.io/vega-lite/docs/scale.html).

-- $color
-- For color interpolation types, see the
-- [Vega-Lite continuous scale documentation](https://vega.github.io/vega-lite/docs/scale.html#continuous).

-- $view
-- Views can be combined to create more complex multiview displays. This may involve
-- layering views on top of each other (superposition) or laying them out in adjacent
-- spaces (juxtaposition using 'VL.repeat', 'VL.repeatFlow', 'VL.facet', 'VL.facetFlow',
-- 'VL.vlConcat', 'VL.hConcat', or 'VL.vConcat'). Where different views have potentially conflicting
-- channels (for example, two position scales in a layered visualization) the rules for
-- resolving them can be defined with 'VL.resolve'. For details of creating composite views see the
-- <https://vega.github.io/vega-lite/docs/composition.html Vega-Lite documentation>.

-- $resolution
-- Control the independence between composed views.
--
-- See the [Vega-Lite resolve documentation](https://vega.github.io/vega-lite/docs/resolve.html).

-- $facetview
-- #facetview#
-- These are small multiples each of which show subsets of the same dataset. The specification
-- determines which field should be used to determine subsets along with their spatial
-- arrangement (in rows or columns). For details see the
-- <https://vega.github.io/vega-lite/docs/facet.html Vega-Lite documentation>.

-- $facetheaders
-- See the
-- [Vega-Lite header documentation](https://vega.github.io/vega-lite/docs/header.html).

-- $selections
-- Selections are the way in which interactions (such as clicking or dragging) can be
-- responded to in a visualization. They transform interactions into data queries.
-- For details, see the
-- <https://vega.github.io/vega-lite/docs/selection.html Vega-Lite documentation>.

-- $selectionresolution
-- Determines how selections are made across multiple views.
-- See the [Vega-lite resolve selection documentation](https://vega.github.io/vega-lite/docs/selection.html#resolve).

-- $conditional
-- To make channel encoding conditional on the result of some interaction, use
-- 'VL.MSelectionCondition', 'VL.TSelectionCondition', or 'VL.HSelectionCondition'. Similarly
-- 'VL.MDataCondition', 'VL.TDataCondition', or 'VL.HDataCondition' will encode a mark
-- conditionally depending on some data properties such as whether a datum is null
-- or an outlier.
--
-- For interaction, once a selection has been defined and named, supplying a set of
-- encodings allow mark encodings to become dependent on that selection.
-- 'VL.MSelectionCondition' is followed firstly a (Boolean) selection and then an
-- encoding if that selection is true and another encoding to be applied if it is false.
-- The color specification below states \"whenever data marks are selected with an
-- interval mouse drag, encode the cylinder field with an ordinal color scheme,
-- otherwise make them grey\":
--
-- @
-- sel = 'VL.selection' . 'VL.select' "myBrush" 'VL.Interval' []
--
-- enc = 'VL.encoding'
--         . 'VL.position' 'VL.X' [ 'VL.PName' \"Horsepower\", 'VL.PmType' 'VL.Quantitative' ]
--         . 'VL.position' 'VL.Y' [ 'VL.PName' \"Miles_per_Gallon\", 'VL.PmType' Quantitative ]
--         . 'VL.color'
--             [ 'VL.MSelectionCondition' ('VL.SelectionName' "myBrush")
--                 [ 'VL.MName' \"Cylinders\", 'VL.MmType' 'VL.Ordinal' ]
--                 [ 'VL.MString' "grey" ]
--             ]
-- @
--
-- In a similar way, 'VL.MDataCondition' will encode a mark depending on whether any
-- predicate tests are satisfied. Unlike selections, multiple conditions and associated
-- encodings can be specified. Each test condition is evaluated in order and only on
-- failure of the test does encoding proceed to the next test. If no tests are true,
-- the encoding in the final parameter is applied in a similar way to @case of@
-- expressions:
--
-- @
-- enc = 'VL.encoding'
--         . 'VL.position' 'VL.X' [ 'VL.PName' \"value\", 'VL.PmType' 'VL.Quantitative' ]
--           . 'VL.color'
--               [ 'VL.MDataCondition'
--                    [ ( 'VL.Expr' "datum.value < 40", [ 'VL.MString' "blue" ] )
--                    , ( 'VL.Expr' "datum.value < 50", [ 'VL.MString' "red" ] )
--                    , ( 'VL.Expr' "datum.value < 60", [ 'VL.MString' "yellow" ] )
--                    ]
--                    [ 'VL.MString' "black" ]
--               ]
-- @
--
-- For more details, see the
-- <https://vega.github.io/vega-lite/docs/condition.html Vega-Lite documentation>.

-- $toplevel
-- These are in addition to the data and transform options described above,
-- and are described in the
-- [Vega-Lite top-level spec documentation](https://vega.github.io/vega-lite/docs/spec.html#top-level-specifications).

-- $title
-- Per-title settings. Use 'VL.TitleStyle' to change the appearance of all
-- titles in a multi-view specification.

-- $viewbackground
-- The background of a single view in a view composition can be styled independently
-- of other views. For more details see the
-- [Vega-Lite view background documentation](https://vega.github.io/vega-lite/docs/spec.html#view-background).

-- $axisconfig
-- See the
-- [Vega-Lite axis config documentation](https://vega.github.io/vega-lite/docs/axis.html#general-config).

-- $scaleconfig
-- See the
-- [Vega-Lite scale configuration documentation](https://vega.github.io/vega-lite/docs/scale.html#scale-config).

-- $scalerangeconfig
-- See the
-- [Vega-Lite scheme configuration documentation](https://vega.github.io/vega/docs/schemes/#scheme-properties).

-- $titleconfig
-- Unlike 'VL.title', these options apply to __all__ titles if multiple views
-- are created. See the
-- [Vega-Lite title configuration documentation](https://vega.github.io/vega-lite/docs/title.html#config).

-- $viewconfig
-- See the
-- [Vega-Lite view configuration documentation](https://vega.github.io/vega-lite/docs/spec.html#config).

-- $facetconfig
-- See the
-- [Vega-Lite facet configuration documentation](https://vega.github.io/vega-lite/docs/facet.html#facet-configuration).

-- $concatconfig
-- See the
-- [Vega-Lite concat configuration documentation](https://vega.github.io/vega-lite/docs/concat.html#concat-configuration).

-- $generaldatatypes
-- In addition to more general data types like integers and string, the following types
-- can carry data used in specifications.

-- $temporaldata
-- See the
-- [Vega-Lite dateTime documentation](https://vega.github.io/vega-lite/docs/types.html#datetime)
-- and the [Vega-Lite time unit documentation](https://vega.github.io/vega-lite/docs/timeunit.html).

-- $update
-- The following section describes how to update code that used
-- an older version of @hvega@.

-- $update0400
-- The @0.4.0.0@ release added a large number of functions, types, and
-- constructors, including:
--
-- 'VL.toVegaLiteSchema' has been added to allow you to specify a
-- different Vega-Lite schema. 'VL.toVegaLite' uses version 3 but
-- version 4 is being worked on as I type this. The 'VL.vlSchema'
-- function has been added, along with 'VL.vlSchema4', 'VL.vlSchema3',
-- and 'VL.vlSchema2' values. The 'VL.toHtmlWith' and 'VL.toHtmlFileWith'
-- functions have been added to support more control over the
-- embedding of the Vega-Lite visualizations, and the versions of
-- the required Javascript libraries used by the @toHtmlXXX@ routines
-- has been updated.
--
-- The 'VL.VLProperty' type now exports its constructors, to support users
-- who may need to tweak or augment the JSON Vega-Lite specification
-- created by @hvega@: see [issue
-- 17](https://github.com/DougBurke/hvega/issues/17). It has also gained
-- several new constructors and associated functions, which are given in
-- brackets after the constructor: 'VL.VLAlign' ('VL.align'); 'VL.VLBounds'
-- ('VL.bounds'); 'VL.VLCenter' ('VL.center', 'VL.centerRC'); 'VL.VLColumns'
-- ('VL.columns'); 'VL.VLConcat' ('VL.vlConcat'); 'VL.VLSpacing' ('VL.alignRC',
-- 'VL.spacing', 'VL.spacingRC'); 'VL.VLUserMetadata' ('VL.usermetadata'); and
-- 'VL.VLViewBackground' ('VL.viewBackground'). It is expected that you will be
-- using the functions rather the constructors!
-- 
-- Four new type aliases have been added: 'VL.Angle', 'VL.Color', 'VL.Opacity',
-- and 'VL.ZIndex'. These do not provide any new functionality but do
-- document intent.
-- 
-- The 'VL.noData' function has been added to let compositions define the
-- source of the data (whether it is from the parent or not), and data
-- sources can be named with 'VL.dataName'. Data can be created with
-- 'VL.dataSequence', 'VL.dataSequenceAs', and 'VL.sphere'. Graticules can be
-- created with 'VL.graticule'.  The 'VL.NullValue' type has been added to
-- 'VL.DataValue' to support data sources that are missing elements, but for
-- more-complex cases it is suggested that you create your data as an
-- Aeson Value and then use 'VL.dataFromJson'. Support for data imputation
-- (creating new values based on existing data) has been added, as
-- discussed below.
-- 
-- The alignment, size, and composition of plots can be defined and
-- changed with 'VL.align', 'VL.alignRC', 'VL.bounds', 'VL.center', 'VL.centerRC',
-- 'VL.columns', 'VL.spacing', and 'VL.spacingRC'.
-- 
-- Plots can be combined and arranged with: 'VL.facet', 'VL.facetFlow',
-- 'VL.repeat', 'VL.repeatFlow', and 'VL.vlConcat'
-- 
-- New functions for use in a 'VL.transform': 'VL.flatten', 'VL.flattenAs',
-- 'VL.fold', 'VL.foldAs', 'VL.impute', and 'VL.stack'.
-- 
-- New functions for use with 'VL.encoding': 'VL.fillOpacity', 'VL.strokeOpacity',
-- 'VL.strokeWidth',
-- 
-- The ability to arrange specifications has added the "flow" option
-- (aka "repeat"). This is seen in the addition of the 'VL.Flow' constructor
-- to the 'VL.Arrangement' type - which is used with 'VL.ByRepeatOp',
-- 'VL.HRepeat', 'VL.MRepeat', 'VL.ORepeat', 'VL.PRepeat', and 'VL.TRepeat'.
-- 
-- The 'VL.Mark' type has gained 'VL.Boxplot', 'VL.ErrorBar', 'VL.ErrorBand', and
-- 'VL.Trail' constructors. The 'VL.MarkProperty' type has gained 'VL.MBorders',
-- 'VL.MBox', 'VL.MExtent', 'VL.MHeight', 'VL.MHRef', 'VL.MLine', 'VL.MMedian', 'VL.MOrder',
-- 'VL.MOutliers', 'VL.MNoOutliers', 'VL.MPoint', 'VL.MRule', 'VL.MStrokeCap', 'VL.MStrokeJoin',
-- 'VL.MStrokeMiterLimit', 'VL.MTicks', 'VL.MTooltip', 'VL.MWidth', 'VL.MX', 'VL.MX2',
-- 'VL.MXOffset', 'VL.MX2Offset', 'VL.MY', 'VL.MY2', 'VL.MYOffset', and 'VL.MY2Offset'
-- constructors.
-- 
-- The 'VL.Position' type has added 'VL.XError', 'VL.XError2', 'VL.YError', and
-- 'VL.YError2' constructors.
-- 
-- The 'VL.MarkErrorExtent' type was added.
-- 
-- The 'VL.BooleanOp' type has gained the 'VL.FilterOp' and 'VL.FilterOpTrans'
-- constructors which lets you use 'VL.Filter' expressions as part of a
-- boolean operation. The 'VL.Filter' type has also gained expresiveness,
-- with the 'VL.FLessThan', 'VL.FLessThanEq', 'VL.FGreaterThan', 'VL.FGreaterThanEq',
-- and 'VL.FValid'.
-- 
-- The 'VL.Format' type has gained the 'VL.DSV' constructor, which allow you
-- to specify the separator character for column data.
-- 
-- The MarkChannel type has been expanded to include: 'VL.MBinned', 'VL.MSort',
-- 'VL.MTitle', and 'VL.MNoTitle'. The PositionChannel type has added
-- 'VL.PHeight', 'VL.PWidth', 'VL.PNumber', 'VL.PBinned', 'VL.PImpute', 'VL.PTitle', and
-- 'VL.PNoTitle' constructors.
-- 
-- The LineMarker and PointMarker types have been added for use with
-- 'VL.MLine' and 'VL.MPoint' respectively (both from 'VL.MarkProperty').
-- 
-- The ability to define the binning property with 
-- 'VL.binAs', 'VL.DBin', 'VL.FBin', 'VL.HBin', 'VL.MBin', 'VL.OBin', 'VL.PBin', and 'VL.TBin' has
-- been expanded by adding the 'VL.AlreadyBinned' and 'VL.BinAnchor'
-- constructors to 'VL.BinProperty', as well as changing the 'VL.Divide'
-- constructor (as described below).
-- 
-- The 'VL.StrokeCap' and 'VL.StrokeJoin' types has been added. These are used
-- with 'VL.MStrokeCap', 'VL.VBStrokeCap', and 'VL.ViewStrokeCap' and
-- 'VL.MStrokeJoin', 'VL.VBStrokeJoin', and 'VL.ViewStrokeJoin' respectively.
-- 
-- The 'VL.StackProperty' constructor has been added with the 'VL.StOffset'
-- and 'VL.StSort' constructors. As discussed below this is a breaking change
-- since the old StackProperty type has been renamed to 'VL.StackOffset'.
-- 
-- The 'VL.ScaleProperty' type has seen significant enhancement, by adding
-- the constructors: 'VL.SAlign', 'VL.SBase', 'VL.SBins', 'VL.SConstant' and
-- 'VL.SExponent'.  THe 'VL.Scale' tye has added 'VL.ScSymLog' 'VL.ScQuantile',
-- 'VL.ScQuantize', and 'VL.ScThreshold'.
-- 
-- The 'VL.SortProperty' type has new constructors: 'VL.CustomSort',
-- 'VL.ByRepeatOp', 'VL.ByFieldOp', and 'VL.ByChannel'. See the breaking-changes
-- section below for the constructors that were removed.
-- 
-- The 'VL.AxisProperty' type has seen significant additions, including:
-- 'VL.AxBandPosition', 'VL.AxDomainColor', 'VL.AxDomainDash',
-- 'VL.AxDomainDashOffset', 'VL.AxDomainOpacity', 'VL.AxDomainWidth',
-- 'VL.AxFormatAsNum', 'VL.AxFormatAsTemporal', 'VL.AxGridColor', 'VL.AxGridDash',
-- 'VL.AxGridDashOffset', 'VL.AxGridOpacity', 'VL.AxGridWidth', 'VL.AxLabelAlign',
-- 'VL.AxLabelBaseline', 'VL.AxLabelNoBound', 'VL.AxLabelBound', 'VL.AxLabelBoundValue',
-- 'VL.AxLabelColor', 'VL.AxLabelNoFlush', 'VL.AxLabelFlush', 'VL.AxLabelFlushValue',
-- 'VL.AxLabelFlushOffset', 'VL.AxLabelFont', 'VL.AxLabelFontSize',
-- 'VL.AxLabelFontStyle', 'VL.AxLabelFontWeight', 'VL.AxLabelLimit',
-- 'VL.AxLabelOpacity', 'VL.AxLabelSeparation', 'VL.AxTickColor', 'VL.AxTickDash',
-- 'VL.AxTickDashOffset', 'VL.AxTickExtra', 'VL.AxTickMinStep', 'VL.AxTickOffset',
-- 'VL.AxTickOpacity', 'VL.AxTickRound', 'VL.AxTickWidth', 'VL.AxNoTitle',
-- 'VL.AxTitleAnchor', 'VL.AxTitleBaseline', 'VL.AxTitleColor', 'VL.AxTitleFont',
-- 'VL.AxTitleFontSize', 'VL.AxTitleFontStyle', 'VL.AxTitleFontWeight',
-- 'VL.AxTitleLimit', 'VL.AxTitleOpacity', 'VL.AxTitleX', and 'VL.AxTitleY'.
-- 
-- The 'VL.AxisConfig' has seen a similar enhancement, and looks similar
-- to the above apart from the constructors do not start with @Ax@.
-- 
-- The 'VL.LegendConfig' type has been significantly expanded and, as
-- discussed in the Breaking Changes section, changed. It has gained:
-- 'VL.LeClipHeight', 'VL.LeColumnPadding', 'VL.LeColumns', 'VL.LeGradientDirection',
-- 'VL.LeGradientHorizontalMaxLength', 'VL.LeGradientHorizontalMinLength',
-- 'VL.LeGradientLength', 'VL.LeGradientOpacity', 'VL.LeGradientThickness',
-- 'VL.LeGradientVerticalMaxLength', 'VL.LeGradientVerticalMinLength',
-- 'VL.LeGridAlign', 'VL.LeLabelFontStyle', 'VL.LeLabelFontWeight',
-- 'VL.LeLabelOpacity', 'VL.LeLabelOverlap', 'VL.LeLabelPadding',
-- 'VL.LeLabelSeparation', 'VL.LeLayout', 'VL.LeLeX', 'VL.LeLeY', 'VL.LeRowPadding',
-- 'VL.LeSymbolBaseFillColor', 'VL.LeSymbolBaseStrokeColor', 'VL.LeSymbolDash',
-- 'VL.LeSymbolDashOffset', 'VL.LeSymbolDirection', 'VL.LeSymbolFillColor',
-- 'VL.LeSymbolOffset', 'VL.LeSymbolOpacity', 'VL.LeSymbolStrokeColor', 'VL.LeTitle',
-- 'VL.LeNoTitle', 'VL.LeTitleAnchor', 'VL.LeTitleFontStyle', 'VL.LeTitleOpacity',
-- and 'VL.LeTitleOrient'.
-- 
-- The 'VL.LegendOrientation' type has gained 'VL.LOTop' and 'VL.LOBottom'.
-- 
-- The 'VL.LegendLayout' and 'VL.BaseLegendLayout' types are new, and used
-- with 'VL.LeLayout' to define the legent orient group.
-- 
-- The 'VL.LegendProperty' type gained: 'VL.LClipHeight', 'VL.LColumnPadding',
-- 'VL.LColumns', 'VL.LCornerRadius', 'VL.LDirection', 'VL.LFillColor',
-- 'VL.LFormatAsNum', 'VL.LFormatAsTemporal', 'VL.LGradientLength',
-- 'VL.LGradientOpacity', 'VL.LGradientStrokeColor', 'VL.LGradientStrokeWidth',
-- 'VL.LGradientThickness', 'VL.LGridAlign', 'VL.LLabelAlign', 'VL.LLabelBaseline',
-- 'VL.LLabelColor', 'VL.LLabelFont', 'VL.LLabelFontSize', 'VL.LLabelFontStyle',
-- 'VL.LLabelFontWeight', 'VL.LLabelLimit', 'VL.LLabelOffset', 'VL.LLabelOpacity',
-- 'VL.LLabelOverlap', 'VL.LLabelPadding', 'VL.LLabelSeparation', 'VL.LRowPadding',
-- 'VL.LStrokeColor', 'VL.LSymbolDash', 'VL.LSymbolDashOffset',
-- 'VL.LSymbolFillColor', 'VL.LSymbolOffset', 'VL.LSymbolOpacity', 'VL.LSymbolSize',
-- 'VL.LSymbolStrokeColor', 'VL.LSymbolStrokeWidth', 'VL.LSymbolType',
-- 'VL.LTickMinStep', 'VL.LNoTitle', 'VL.LTitleAlign', 'VL.LTitleAnchor',
-- 'VL.LTitleBaseline', 'VL.LTitleColor', 'VL.LTitleFont', 'VL.LTitleFontSize',
-- 'VL.LTitleFontStyle', 'VL.LTitleFontWeight', 'VL.LTitleLimit', 'VL.LTitleOpacity',
-- 'VL.LTitleOrient', 'VL.LTitlePadding', 'VL.LeX', and 'VL.LeY'.
-- 
-- 'VL.Projection' has gained the 'VL.Identity' constructor. The
-- 'VL.ProjectionProperty' type has gained 'VL.PrScale', 'VL.PrTranslate',
-- 'VL.PrReflectX', and 'VL.PrReflectY'. The 'VL.GraticuleProperty' type was
-- added to configure the appearance of graticules created with
-- 'VL.graticule'.
-- 
-- The 'VL.CompositionAlignment' type was added and is used with 'VL.align',
-- 'VL.alignRC', 'VL.LeGridAlign', and 'VL.LGridAlign'.
-- 
-- The 'VL.Bounds' type was added for use with 'VL.bounds'.
-- 
-- The 'VL.ImputeProperty' and 'VL.ImMethod' types were added for use with
-- 'VL.impute' and 'VL.PImpute'.
-- 
-- The 'VL.ScaleConfig' type has gained 'VL.SCBarBandPaddingInner',
-- 'VL.SCBarBandPaddingOuter', 'VL.SCRectBandPaddingInner', and
-- 'VL.SCRectBandPaddingOuter'.
-- 
-- The 'VL.SelectionProperty' type has gained 'VL.Clear', 'VL.SInit', and
-- 'VL.SInitInterval'.
-- 
-- The Channel type has gained: 'VL.ChLongitude', 'VL.ChLongitude2',
-- 'VL.ChLatitude', 'VL.ChLatitude2', 'VL.ChFill', 'VL.ChFillOpacity', 'VL.ChHref',
-- 'VL.ChKey', 'VL.ChStroke', 'VL.ChStrokeOpacity'.  'VL.ChStrokeWidth', 'VL.ChText',
-- and 'VL.ChTooltip'.
-- 
-- The 'VL.TitleConfig' type has gained: 'VL.TFontStyle', 'VL.TFrame', 'VL.TStyle',
-- and 'VL.TZIndex'.
-- 
-- The 'VL.TitleFrame' type is new and used with 'VL.TFrame' from 'VL.TitleConfig'.
-- 
-- The 'VL.ViewBackground' type is new and used with 'VL.viewBackground'.
-- 
-- The 'VL.ViewConfig' type has gained 'VL.ViewCornerRadius', 'VL.ViewOpacity',
-- 'VL.ViewStrokeCap', 'VL.ViewStrokeJoin', and 'VL.ViewStrokeMiterLimit'.
-- 
-- The 'VL.ConfigurationProperty' type, used with 'VL.configuration', has
-- gained 'VL.ConcatStyle', 'VL.FacetStyle', 'VL.GeoshapeStyle', 'VL.HeaderStyle',
-- 'VL.NamedStyles', and 'VL.TrailStyle' constructors.
-- 
-- The 'VL.ConcatConfig' type was added for use with the 'VL.ConcatStyle',
-- and the 'VL.FacetConfig' type for the 'VL.FacetStyle'
-- configuration settings.
-- 
-- The 'VL.HeaderProperty' type has gained: 'VL.HFormatAsNum',
-- 'VL.HFormatAsTemporal', 'VL.HNoTitle', 'VL.HLabelAlign', 'VL.HLabelAnchor',
-- 'VL.HLabelAngle', 'VL.HLabelColor', 'VL.HLabelFont', 'VL.HLabelFontSize',
-- 'VL.HLabelLimit', 'VL.HLabelOrient', 'VL.HLabelPadding', 'VL.HTitleAlign',
-- 'VL.HTitleAnchor', 'VL.HTitleAngle', 'VL.HTitleBaseline', 'VL.HTitleColor',
-- 'VL.HTitleFont', 'VL.HTitleFontSize', 'VL.HTitleFontWeight', 'VL.HTitleLimit',
-- 'VL.HTitleOrient', and 'VL.HTitlePadding'.
-- 
-- The 'VL.HyperlinkChannel' type has gained 'VL.HBinned'.
-- 
-- The 'VL.FacetChannel' type has gained 'VL.FSort', 'VL.FTitle', and 'VL.FNoTitle'.
-- 
-- The 'VL.TextChannel' type has gained 'VL.TBinned', 'VL.TFormatAsNum',
-- 'VL.TFormatAsTemporal', 'VL.TTitle', and 'VL.TNoTitle'.
-- 
-- The 'VL.TooltipContent' type was added, for use with 'VL.MTooltip'.
--
-- The 'VL.Symbol' type has gained: 'VL.SymArrow', 'VL.SymStroke',
-- 'VL.SymTriangle', 'VL.SymTriangleLeft', 'VL.SymTriangleRight', and
-- 'VL.SymWedge'.
--
-- There are a number of __breaking changes__ in this release (some
-- of which were mentioned above):
--
-- * The 'VL.title' function now takes a second argument, a list of 'VL.TitleConfig'
--   values for configuring the appearance of the title.
--
-- * The @SReverse@ constructor was removed from 'VL.ScaleProperty' as it
--   represented a Vega, rather than Vega-Lite, property. The @xSort@
--   constructors are used to change the order of an item (e.g.
--   'VL.PSort', 'VL.MSort').
--
-- * The @ScSequential@ constructor was removed from 'VL.Scale' as
--   'VL.ScLinear' should be used.
--
-- * The 'VL.SortProperty' type has had a number of changes: the @Op@,
--   @ByField@, and @ByRepeat@ constructors have been removed, and
--   'VL.ByRepeatOp', 'VL.ByFieldOp', and 'VL.ByChannel' constructors have been
--   added.
--
-- * The @AxTitleMaxLength@ and @TitleMaxLength@ constructors have been
--   removed (from 'VL.AxisProperty' and 'VL.AxisConfig' respectively) as they
--   are invalid. The 'VL.AxTitleLimit' (new in this release) and
--   'VL.TitleLimit' constructors should be used instead.
--
-- * 'VL.AxisProperty': the 'VL.AxValues' constructor has been changed from
--   accepting a list of doubles to 'VL.DataValues'. The 'VL.AxDates'
--   constructor has been deprecated and 'VL.AxValues' should be used
--   instead.
--
-- * There have been significant changes to the 'VL.LegendConfig' type: the
--   @EntryPadding@, @GradientHeight@, @GradientLabelBaseline@,
--   @GradientWidth@, and @SymbolColor@ constructors have been removed;
--   the renaming constructors have been renamed so they all begin with
--   @Le@ (e.g. @Orient@ is now 'VL.LeOrient', and 'VL.Orient' has been added
--   to 'VL.AxisConfig'); and new constructors have been added.
--
-- * The @StackProperty@ type has been renamed to 'VL.StackOffset' and its
--   constructors have changed, and a new 'VL.StackProperty'
--   type has been added (that references the 'VL.StackOffset' type).
--
-- * The @Average@ constructor of 'VL.Operation' was removed, and 'VL.Mean'
--   should be used instead.
--
-- * The @LEntryPadding@ constructor of 'VL.LegendProperty' was removed.
--
-- * The arguments to the 'VL.MDataCondition', 'VL.TDataCondition', and
--   'VL.HDataCondition' constructors - of 'VL.MarkChannel', 'VL.TextChannel',
--   and 'VL.HyperlinkChannel' respectively - have changed to support
--   accepting multiple expressions.
--
-- * The @MarkOrientation@ type has been renamed 'VL.Orientation'.
--
-- * The constructors of the 'VL.ViewConfig' type have been renamed so they
--   all begin with @View@ (to match 'VL.ViewWidth' and 'VL.ViewHeight').
--
-- * The constructors of the 'VL.ProjectionProperty' type have been renamed
--   so that they begin with @Pr@ rather than @P@ (to avoid conflicts
--   with the 'VL.PositionChannel' type).
--
-- * The 'VL.Divide' constructor of 'VL.BinProperty' now takes a list of
--   Doubles rather than two.
--
-- * The 'VL.TitleConfig' type has gained the following constructors:
--   'VL.TFontStyle', 'VL.TFrame', 'VL.TStyle', and 'VL.TZIndex'. The 'VL.TitleFrame'
--   type was added for use with 'VL.TFrame'.
--
-- * The 'VL.ArgMax' and 'VL.ArgMin' constructors of 'VL.Operation' now take an
--   optional field name, to allow them to be used as part of an encoding
--   aggregation (e.g. with 'VL.PAggregate').
--
-- * The \"z index" value has changed from an 'VL.Int' to the 'VL.ZIndex' type.
--
-- * The constructors for the 'VL.Symbol' type now all start with @Sym@, so
--   @Cross@, @Diamond@, @TriangleUp@, @TriangleDown@, and @Path@ have
--   been renamed to 'VL.SymCross', 'VL.SymDiamond', 'VL.SymTriangleUp',
--   'VL.SymTriangleDown', and 'VL.SymPath', respectively.
--
-- * The @Legend@ type has been renamed 'VL.LegendType' and its constructors
--   have been renamed 'VL.GradientLegend' and 'VL.SymbolLegend'.


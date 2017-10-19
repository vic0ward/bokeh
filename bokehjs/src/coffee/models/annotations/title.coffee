import {TextAnnotation, TextAnnotationView} from "./text_annotation"
import {hide} from "core/dom"
import * as p from "core/properties"
import * as Visuals from "core/visuals"

export class TitleView extends TextAnnotationView

  _get_location: () ->
    panel = @model.panel
    offset = @model.offset

    switch panel.side
      when 'above', 'below'
        switch @model.text_baseline
          when 'top'    then vy = panel._top.value
          when 'middle' then vy = panel._vcenter.value
          when 'bottom' then vy = panel._bottom.value

        switch @model.text_align
          when 'left'   then vx = panel._left.value    + offset
          when 'center' then vx = panel._hcenter.value
          when 'right'  then vx = panel._right.value   - offset
      when 'left'
        switch @model.text_baseline
          when 'top'    then vx = panel._left.value
          when 'middle' then vx = panel._hcenter.value
          when 'bottom' then vx = panel._right.value

        switch @model.text_align
          when 'left'   then vy = panel._bottom.value  + offset
          when 'center' then vy = panel._vcenter.value
          when 'right'  then vy = panel._top.value     - offset
      when 'right'
        switch @model.text_baseline
          when 'top'    then vx = panel._right.value
          when 'middle' then vx = panel._hcenter.value
          when 'bottom' then vx = panel._left.value

        switch @model.text_align
          when 'left'   then vy = panel._top.value     - offset
          when 'center' then vy = panel._vcenter.value
          when 'right'  then vy = panel._bottom.value  + offset

    sx = @canvas.vx_to_sx(vx)
    sy = @canvas.vy_to_sy(vy)
    return [sx, sy]

  render: () ->
    if not @model.visible
      if @model.render_mode == 'css'
        hide(@el)
      return

    text = @model.text
    if not text? or text.length == 0
      return

    [sx, sy] = @_get_location()
    angle = @model.panel.get_label_angle_heuristic('parallel')

    ctx = @plot_view.canvas_view.ctx

    if @model.render_mode == 'canvas'
      @_canvas_text(ctx, text, sx, sy, angle)
    else
      @_css_text(ctx, text, sx, sy, angle)

  _get_size: () ->
    text = @model.text
    if not text? or text.length == 0
      return 0
    else
      ctx = @plot_view.canvas_view.ctx
      @visuals.text.set_value(ctx)
      return ctx.measureText(text).ascent + 10

export class Title extends TextAnnotation
  default_view: TitleView

  type: 'Title'

  @mixins ['text', 'line:border_', 'fill:background_']

  @define {
    text:            [ p.String,              ]
    offset:          [ p.Number,     0        ]
    render_mode:     [ p.RenderMode, 'canvas' ]
  }

  @override {
    text_font_size: "10pt"
    text_font_style: "bold"
    background_fill_color: null
    border_line_color: null
  }

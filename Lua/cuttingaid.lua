
local lib_cuttingaid  = {}   -- public interface
local lib_cuttingaid_ = {}   -- private functions


function lib_cuttingaid_.place_text(pos_x, pos_y, text, anchor, text_color, bg_color, font_size)

  -- "anchor" can have values like "north west", etc.
  
  -- "font_size" can have the standard LaTeX text sizes, i.e.:
  --   "tiny"
  --   "scriptsize"
  --   "footnotesize"
  --   "small"
  --   "normalsize"
  --   "large"
  --   "Large"
  --   "LARGE"
  --   "huge"
  --   "Huge"

  tex.print(string.format("\\node[inner xsep=0, inner ysep=0, outer sep=0, anchor=%s, color=%s, fill=%s, font=\\%s, align=center] at (%.10fmm, %.10fmm) {%s};", anchor, text_color, bg_color, font_size, pos_x, pos_y, text))

  -- tex.print(string.format("\\node[inner xsep=0, inner ysep=0, outer sep=0, anchor=%s, fill=%s, minimum width=\\gridunitsize, minimum height=\\gridunitsize, align=left] at (%.10fmm, %.10fmm) {%s};", anchor, fill_color, pos_x, pos_y, text))

end


function lib_cuttingaid.rendercuttingaid(name, target_width_mm, target_height_mm, margin_mm)
      
  local margin_x = margin_mm
  local margin_y = margin_mm
    
  local page_width  = target_width_mm  + 2 * margin_x
  local page_height = target_height_mm + 2 * margin_y
  
  local desk_actual_center_x = target_width_mm  * 0.5
  local desk_actual_center_y = target_height_mm * 0.5
  
  local desk_orig_center_x = 1800 * 0.5
  local desk_orig_center_y = 800  * 0.5
  
  local page_center_x = page_width  * 0.5
  local page_center_y = page_height * 0.5
  
    
  local target = {
    x_left                       = margin_x,
    x_right                      = margin_x + target_width_mm,
    y_top                        = margin_y,
    y_bottom                     = margin_y + target_height_mm,
    offset_origdesk_page_x       = page_center_x - desk_orig_center_x,
    offset_origdesk_page_y       = page_center_y - desk_orig_center_y,
    offset_origdesk_actualdesk_x = desk_actual_center_x - desk_orig_center_x,
    offset_origdesk_actualdesk_y = desk_actual_center_y - desk_orig_center_y,
  }
  
  
  -- Page clipping
  tex.print(string.format("\\clip (0mm, 0mm) rectangle (%s, %s);", page_width .. "mm", page_height .. "mm"))

  -- Description text at the top left of the page
  local desc = name .. "\\\\(" .. target_width_mm .. " mm $\\times$ " .. target_height_mm .. " mm)"
  lib_cuttingaid_.place_text(0, 0, desc, "north west", "black", "yellow", "tiny")

  
  -- Draw helper lines
  local helper_line_color = "gray"
  local helper_line_width = "0.5pt"
  
  -- Top
  tex.print(string.format("\\draw [line width=%s, line cap=round, style=densely dotted, color=%s] (%.10fmm, %.10fmm) -- (%.10fmm, %.10fmm);", helper_line_width, helper_line_color, 0, target.y_top, page_width, target.y_top))
  
  -- Bottom
  tex.print(string.format("\\draw [line width=%s, line cap=round, style=densely dotted, color=%s] (%.10fmm, %.10fmm) -- (%.10fmm, %.10fmm);", helper_line_width, helper_line_color, 0, target.y_bottom, page_width, target.y_bottom))
  
  -- Left
  tex.print(string.format("\\draw [line width=%s, line cap=round, style=densely dotted, color=%s] (%.10fmm, %.10fmm) -- (%.10fmm, %.10fmm);", helper_line_width, helper_line_color, target.x_left, 0, target.x_left, page_height))
  
  -- Right
  tex.print(string.format("\\draw [line width=%s, line cap=round, style=densely dotted, color=%s] (%.10fmm, %.10fmm) -- (%.10fmm, %.10fmm);", helper_line_width, helper_line_color, target.x_right, 0, target.x_right, page_height))
  
  
  -- Draw target outline
  local outline_line_color = "black"
  local outline_line_width = "0.5pt"
  
  -- Top
  tex.print(string.format("\\draw [line width=%s, line cap=round, color=%s] (%.10fmm, %.10fmm) -- (%.10fmm, %.10fmm);", outline_line_width, outline_line_color, target.x_left, target.y_top, target.x_right, target.y_top))
  
  -- Bottom
  tex.print(string.format("\\draw [line width=%s, line cap=round, color=%s] (%.10fmm, %.10fmm) -- (%.10fmm, %.10fmm);", outline_line_width, outline_line_color, target.x_left, target.y_bottom, target.x_right, target.y_bottom))
  
  -- Left
  tex.print(string.format("\\draw [line width=%s, line cap=round, color=%s] (%.10fmm, %.10fmm) -- (%.10fmm, %.10fmm);", outline_line_width, outline_line_color, target.x_left, target.y_top, target.x_left, target.y_bottom))
  
  -- Right
  tex.print(string.format("\\draw [line width=%s, line cap=round, color=%s] (%.10fmm, %.10fmm) -- (%.10fmm, %.10fmm);", outline_line_width, outline_line_color, target.x_right, target.y_top, target.x_right, target.y_bottom))
  
end


return lib_cuttingaid

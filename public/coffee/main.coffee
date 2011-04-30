google.load('language', '1')

$ ->
  xyGraphArea = new XYGraphArea()
  initCategorySelection()
  initAxisMenu(xyGraphArea)

# カテゴリメニューを切り替えると再検索
initCategorySelection = ->
  $("form.search").each (i, formElem) ->
    $(formElem).find("select[name='category']").change (event) ->
      $(formElem).submit()

initAxisMenu = (xyGraphArea) ->
  xMenuItems = [
    ['Price', AxisType.LowestPrice]
    ['Sales Rank', AxisType.PvRanking]
    ['Sale Date', AxisType.SaleDate]
    ['Reviews', AxisType.NumOfBbs]
    ['Satisfaction', AxisType.TotalScoreAve]
    ['Montor Size', AxisType.MonitorSize]
    ['HDD Size', AxisType.HDDSize]
    ['Memory Size', AxisType.MemorySize]
    ['Noise Level', AxisType.Noise]
    ['Weight', AxisType.Weight]
  ]
  yMenuItems = [
    ['Sales Rank', AxisType.PvRanking]
    ['Price', AxisType.LowestPrice]
    ['Sale Date', AxisType.SaleDate]
    ['Reviews', AxisType.NumOfBbs]
    ['Satisfaction', AxisType.TotalScoreAve]
    ['Monitor Size', AxisType.MonitorSize]
    ['HDD Size', AxisType.HDDSize]
    ['Memory Size', AxisType.MemorySize]
    ['Noise Level', AxisType.Noise]
    ['Weight', AxisType.Weight]
  ]
  for item in xMenuItems
    $('#x-axis-menu').append(
      $('<option/>').text(item[0]).val(item[1]))
  for item in yMenuItems
    $('#y-axis-menu').append(
      $('<option/>').text(item[0]).val(item[1]))
  $('#x-axis-menu').change ->
    value = $(this).val()
    xyGraphArea.switchXAxis value
  $('#y-axis-menu').change ->
    value = $(this).val()
    xyGraphArea.switchYAxis value

#
# Extend jQuery
#
jQuery.fn.extend {
  integer: () -> parseInt(this.text())

  number: () -> parseFloat(this.text())

  unselectable: () ->
    this.each ->
      $(this).attr({
        unselectable: "on" # IE
      }).css({
        "-moz-user-select":    "none"
        "-khtml-user-select":  "none"
        "-webkit-user-select": "none"
        "user-select": "none" # CSS3
      })

  selectable: () ->
    this.each ->
      $(this).attr({
        unselectable: "off" # IE
      }).css({
        "-moz-user-select": "auto"
        "-khtml-user-select": "auto"
        "-webkit-user-select": "auto"
        "user-select": "auto" # CSS3
      })
}


jQuery.log = (obj) ->
  if window.console
    console.log(obj)

jQuery.any = (array, callback) ->
  for i in [0...array.length]
    if callback.call(this, i, array[i])
      return true
  false

jQuery.min = (a, b) ->
  if a < b then a else b

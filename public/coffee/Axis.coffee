AxisType = {
  SaleDate:      'SaleDate'
  PvRanking:     'PvRanking'
  TotalScoreAve: 'TotalScoreAve' # 満足度
  LowestPrice:   'LowestPrice'
  NumOfBbs:      'NumOfBbs'

  MonitorSize:   'MonitorSize'
  HDDSize:       'HDDSize'
  MemorySize:    'MemorySize'
  Noise:         'Noise'
  Weight:        'Weight'
}

class Axis
  constructor: (@axisType) ->

  getUnit:() ->
    switch (@axisType.toString())
      when AxisType.SaleDate
        'days ago'
      when AxisType.PvRanking
        ''
      when AxisType.TotalScoreAve
        ''
      when AxisType.LowestPrice
        'yen'
      when AxisType.NumOfBbs
        'comments'
      when AxisType.MonitorSize
        'inch'
      when AxisType.HDDSize
        'GB'
      when AxisType.MemorySize
        'GB'
      when AxisType.Noise
        'db'
      when AxisType.Weight
        'g'
      else ''

  getLabel: ->
    switch (@axisType)
      when AxisType.SaleDate
        'Later'
      when AxisType.PvRanking
        'Higher'
      when AxisType.TotalScoreAve
        'Lower'
      when AxisType.LowestPrice
        'Lower'
      when AxisType.NumOfBbs
        'Fewer'
      when AxisType.MonitorSize
        'Smaller'
      when AxisType.HDDSize
        'Larger capacity'
      when AxisType.MemorySize
        'Smaller capacity'
      when AxisType.Noise
        'Silent'
      when AxisType.Weight
        'Lighter'
      else ''

  isLogScale: () ->
    return (@axisType.toString() == AxisType.PvRanking)

  createScale: (scaleMode, paddingHead=0, paddingFoot=0, desc=false) ->
    thick = if (scaleMode == ScaleMode.HORIZONTAL) then 50 else 100
    if @isLogScale()
      new LogAxisScale(thick, scaleMode, @getUnit(), paddingHead, paddingFoot)
    else
      new AxisScale(thick, scaleMode, @getUnit(), paddingHead, paddingFoot)

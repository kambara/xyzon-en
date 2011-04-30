class Category
  @enToKey: {
    'パソコン': 'Pc'
    '家電':     'Kaden'
    'カメラ':   'Camera'
    'ゲーム':   'Game'
#   '楽器':     'Gakki'
    '自動車・バイク':      'Kuruma'
    'スポーツ・アウトドア': 'Sports'
#   'ブランド・腕時計':    'Brand'
    'ベビー・キッズ':      'Baby'
    'ペット':             'Pet'
    'ビューティー・ヘルス': 'Beauty_Health'
  }

  @keyToEn: {
    'Pc':     'Computers'
    'Kaden':  'Electronics'
    'Camera': 'Camera'
    'Game':   'Games'
    'Kuruma': 'Automotive Parts'
    'Sports': 'Sports'
    'Baby':   'Kids & Baby'
    'Pet':    'Pets'
    'Beauty_Health': 'Health & Beauty'
  }

  @jaToKey: {
    'パソコン': 'Pc'
    '家電':     'Kaden'
    'カメラ':   'Camera'
    'ゲーム':   'Game'
#   '楽器':     'Gakki'
    '自動車・バイク':      'Kuruma'
    'スポーツ・アウトドア': 'Sports'
#   'ブランド・腕時計':    'Brand'
    'ベビー・キッズ':      'Baby'
    'ペット':             'Pet'
    'ビューティー・ヘルス': 'Beauty_Health'
  }

  @keyToJa: {
    'Pc':     'パソコン'
    'Kaden':  '家電'
    'Camera': 'カメラ'
    'Game':   'ゲーム'
    'Kuruma': '自動車・バイク'
    'Sports': 'スポーツ・アウトドア'
    'Baby':   'ベビー・キッズ'
    'Pet':    'ペット'
    'Beauty_Health': 'ビューティー・ヘルス'
  }

  @getKeyFromJa: (ja) ->
    Category.jaToKey[ja]

  @getEnFromKey: (key) ->
    Category.keyToEn[key]

  @getJaFromKey: (key) ->
    Category.keyToJa[key]

class CategoryList
  constructor: ->
    @categories_ = []

  add: (categoryName) ->
    @categories_.push( categoryName.split('>') )

  recommend: () ->
    buf = {}
    for cat in @categories_
      name = cat[0]
      buf[name] = if buf[name] then buf[name]+1 else 1
    @sortObj(buf)

  recommendSub: (categoryKey) ->
    categoryName = Category.getJaFromKey(categoryKey)
    buf = {}
    for cat in @categories_
      top = cat[0]
      name = cat[cat.length - 1]
      if top == categoryName
        buf[name] = if buf[name] then buf[name]+1 else 1
    @sortObj(buf)

  # {name: num} となっているオブジェクトを逆ソート
  sortObj: (obj) ->
    ary = ({name:name, num:num} for name, num of obj)
    ary = ary.sort((a, b) -> b.num - a.num)
    for item in ary
      $.log(item.name + " " + item.num)
    (item.name for item in ary)
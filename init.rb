$init = {
  _dijiuzww: {
    host: 'http://www.dijiuzww.com',
    coding: 'GBK',
    search: {
      type: 'post',
      href: '/pdnovel.php',
      opt: {
        srchtxt: :book_name,
        mod:'search', 
        searchsubmit: 'yes'
      }
    },
    confirm: [ '阅读', '进入章节目录'],
    listcss: 'dl dd a',
    body:{
      sub:{
            '    '=>"\n",
            ' '=>' ',
            'www.dijiuzww.com 好看的小说 就来第，九，中 文=网>！高品质无弹窗更新'=>' ',
            /【第，九~中~~.*“网】/ => ' ',
            '〖∷更新快∷无弹窗∷纯文字∷ 〗' => ' '
      },
      css: 'p.pdp',
      href: :host
    }
  },
  _dhzw:{
    host: 'http://www.dhzw.com',
    coding: 'GBK',
    search: {
      type: 'post',
      href: '/modules/article/search.php',
      opt: {searchkey: :book_name}
    },
    confirm: [:book_name],
    listcss: 'dl dd a',
    body:{
      sub: {
        '    '=>"\n",
        ' '=>' '
      },
      css: 'div#BookText',
      href: :body_href
    }
  },
  _7dsw:{
    host: 'http://www.7dsw.com',
    coding: 'GBK',
    search: {
      type: 'post',
      href: '/modules/article/search.php',
      opt: {searchkey: :book_name}
    },
    confirm: [:book_name],
    listcss: 'tr td a',
    body:{
      sub: {
        '    '=>"\n",
        ' '=>' '
      },
      css: 'div#content',
      href: :body_href
    }
  }
}
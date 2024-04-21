return {
  'kylechui/nvim-surround',
  lazy = false,
  config = function()
    require('nvim-surround').setup()

    --     Old text                    Command         New text
    -- --------------------------------------------------------------------------------
    --     surround_words             ysiw)           (surround_words)
    --     *make strings               ys$"            "make strings"
    --     [delete around me!]        ds]             delete around me!
    --     remove <b>HTML *ags</b>    dst             remove HTML tags
    --     'change quot*es'            cs'"            "change quotes"
    --     <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
    --     delete(function calls)     dsf             function calls
  end
}

return {
  {
    'delphinus/md-render.nvim',
    version = '*',
    cmd = 'MdRender',
    keys = {
      { '<leader>mp', '<Plug>(md-render-preview)', desc = 'Markdown [P]review' },
      { '<leader>ms', '<Plug>(md-render-split)', desc = 'Markdown [S]plit preview' },
      { '<leader>mt', '<Plug>(md-render-toggle)', desc = 'Markdown render [T]oggle' },
    },
  },
}

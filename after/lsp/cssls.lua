local capabilities = require('util.lsp').make_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
return {
  {
    capabilities = capabilities,
  },
}

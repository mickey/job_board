require 'dragonfly'

app = Dragonfly[:images]
app.configure_with(:rmagick)
app.configure_with(:rails)

app.define_macro_on_include(MongoMapper::Document, :image_accessor)
app.define_macro_on_include(MongoMapper::EmbeddedDocument, :image_accessor)
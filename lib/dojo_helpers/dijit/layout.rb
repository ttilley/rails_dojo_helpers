module DojoHelpers
  module Dijit
    module Layout
    end
  end
end

ActionView::Base.class_eval {include DojoHelpers::Dijit::Layout}

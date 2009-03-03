module DojoHelpers
  module Dijit
    def dijit_content(content_or_html_options_with_block = nil, html_options_or_options_with_block = {}, options = {}, &block)
      if block_given?
        html_options = content_or_html_options_with_block if content_or_html_options_with_block.is_a?(Hash)
        options = html_options_or_options_with_block
        content = capture(&block)
      else
        content = content_or_html_options_with_block
        html_options = html_options_or_options_with_block
      end

      ::DojoHelpers::Dijit.core_options(html_options, options)

      unless html_options['dojoType']
        html_options.reverse_merge!({
            'dojoType' => 'dijit.layout.ContentPane',
            'parseOnLoad' => true,
            'extractContent' => false,
            'preventCache' => true,
            'preLoad' => false,
            'refreshOnShow' => false
          })

        unless not options['dojox_content_pane']
          html_options['dojoType'] = 'dojox.layout.ContentPane'
          html_options.reverse_merge!({
              'adjustPaths' => false,
              'cleanContent' => false,
              'renderStyles' => true,
              'executeScripts' => true
            })
        end
        
        if options['smoothScroll']
          duration = options['duration'] || 1000
          smoothScroll = "dojox.fx.smoothScroll({node:this.domNode,win:dojo.global,duration:#{duration}}).play();"
          default = "return this.loadingMessage;"
          html_options['onDownloadStart'] = "#{smoothScroll}#{default}"
        end
      end

      dijit_content = content_tag(options['tag'], content, html_options)

      if block_given? && block_is_within_action_view?(block)
        concat(dijit_content, block.binding)
      else
        dijit_content
      end
    end

    class << self
      def get_options(html_options = {}, options = nil)
        html_options.stringify_keys!
        options ||= {}

        options_from_html_options = html_options.delete('dijit')
        options.reverse_merge!(options_from_html_options) if options_from_html_options

        [html_options, options]
      end

      def core_options(html_options = {}, options = nil)
        html_options, options = get_options(html_options, options)

        options.reverse_merge!({
            'global' => true,
            'tag' => 'div'
          })

        if options['global'] && html_options['id']
          html_options['jsId'] = html_options['id'].camelcase(:lower)
        end
      end

      def form_options(html_options = {}, options = {})
        core_options(html_options, options)

        html_options.reverse_merge!({
            'alt' => html_options['title'] || '',
            'disabled' => false,
            'readOnly' => false,
            'intermediateChanges' => true,
            'scrollOnFocus' => true
          })
      end

      def textbox_options(html_options = {}, options_or_method = nil, method = nil)
        method ||= options_or_method if options_or_method.is_a?(String)
        options = options_or_method if options_or_method.is_a?(Hash)

        form_options(html_options, options)

        textbox_options = {
          'trim' => true,
          'tooltipPosition' => "before",
          'title' => html_options['title'] || method.to_s.capitalize.sub('_', '')
        }

        if html_options['required'] || html_options.delete('validation')
          textbox_options['dojoType'] = 'dijit.form.ValidationTextBox'
          textbox_options['promptMessage'] = textbox_options['title']
        else
          textbox_options['dojoType'] = 'dijit.form.TextBox'
        end

        html_options.reverse_merge!(textbox_options)
        html_options['alt'] = textbox_options['title'] if html_options['alt'].blank?
      end
    end
  end
end

ActionView::Base.class_eval {include DojoHelpers::Dijit}

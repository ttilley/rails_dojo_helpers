module DojoHelpers
  module Dijit
    module Form
      def dijit_form_for(record_or_name_or_array, *args, &proc)
        html_options = args.extract_options!
        ::DojoHelpers::Dijit.form_options(html_options)
        form_for(record_or_name_or_array, *(args << html_options), &proc)
      end

      def dijit_text_field(object_name, method, html_options = {})
        ::DojoHelpers::Dijit.textbox_options(html_options, method)
        text_field(object_name, method, html_options)
      end

      def dijit_password_field(object_name, method, html_options = {})
        ::DojoHelpers::Dijit.textbox_options(html_options, method)
        password_field(object_name, method, html_options)
      end

      def dijit_text_area(object_name, method, html_options = {})
        ::DojoHelpers::Dijit.form_options(html_options)
        html_options['dojoType'] ||= 'dijit.form.TextArea'
        text_area(object_name, method, html_options)
      end

      def dijit_check_box(object_name, method, html_options = {}, checked_value = "1", unchecked_value = "0")
        ::DojoHelpers::Dijit.form_options(html_options)
        html_options['dojoType'] ||= 'dijit.form.CheckBox'
        check_box(object_name, method, html_options, checked_value, unchecked_value)
      end

      def dijit_check_box_tag(name, value = "1", checked = false, html_options = {})
        ::DojoHelpers::Dijit.form_options(html_options)
        html_options['dojoType'] ||= 'dijit.form.CheckBox'
        check_box_tag(name, value, checked, html_options)
      end

      def dijit_select(object, method, choices, select_options = {}, html_options = {})
        ::DojoHelpers::Dijit.form_options(html_options)
        html_options.reverse_merge!({
            'dojoType' => 'dijit.form.FilteringSelect',
            'autoComplete' => true,
            'highlightMatch' => 'all',
            'ignoreCase' => true,
            'hasDownArrow' => true
          })
        select(object, method, choices, select_options, html_options)
      end

      def dijit_button(content = '', html_options = {}, options = {})
        options['tag'] ||= 'button'
        ::DojoHelpers::Dijit.form_options(html_options, options)

        if content.blank? and not html_options['iconClass']
          raise("a dijit button must have content or an iconClass set")
        end

        html_options.reverse_merge!({
            'dojoType' => 'dijit.form.Button',
            'type' => 'button',
            'showLabel' => content.blank? ? false : true
          })

        dijit_content(content, html_options, options)
      end

      def dijit_submit_button(content = '', html_options = {}, options = {})
        html_options['type'] ||= 'submit'
        dijit_button(content, html_options, options)
      end

      def dijit_reset_button(content = '', html_options = {}, options = {})
        html_options['type'] ||= 'reset'
        dijit_button(content, html_options, options)
      end
      
      def dijit_button_to(name, url_options={}, html_options={}, options={})
        url = url_options.is_a?(String) ? url_options : self.url_for(url_options)
        html_options['onClick'] = "window.location = '#{url}';"
        name = url if name.blank?
        dijit_button(name, html_options, options)
      end
      
      def dijit_toolbar(content_or_html_options_with_block = nil, html_options_or_options_with_block = {}, options = {}, &block)        
        if block_given?
          html_options = content_or_html_options_with_block if content_or_html_options_with_block.is_a?(Hash)
          options = html_options_or_options_with_block
          content = capture(&block)
        else
          content = content_or_html_options_with_block
          html_options = html_options_or_options_with_block
        end
        
        html_options['dojoType'] ||= 'dijit.Toolbar'
        dijit_content = dijit_content(content, html_options, options)

        if block_given? && block_is_within_action_view?(block)
          concat(dijit_content, block.binding)
        else
          dijit_content
        end
      end
      
      def dijit_toolbar_separator(html_options={}, options={})
        html_options['dojoType'] ||= 'dijit.ToolbarSeparator'
        dijit_content('', html_options, options)
      end
    end
  end
end

ActionView::Base.class_eval {include DojoHelpers::Dijit::Form}

module ActionView
  module Helpers
    class FormBuilder
      def dijit_text_field(method, options = {})
        @template.dijit_text_field(@object_name, method, options.merge(:object => @object))
      end

      def dijit_password_field(method, options = {})
        @template.dijit_password_field(@object_name, method, options.merge(:object => @object))
      end

      def dijit_text_area(method, options = {})
        @template.dijit_text_area(@object_name, method, options.merge(:object => @object))
      end

      def dijit_check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
        @template.dijit_check_box(@object_name, method, options.merge(:object => @object), checked_value, unchecked_value)
      end

      def dijit_select(method, choices, options = {}, html_options = {})
        @template.dijit_select(@object_name, method, choices, options.merge(:object => @object), html_options)
      end
    end
  end
end

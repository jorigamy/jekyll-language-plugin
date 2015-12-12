module Jekyll
  class LanguagePage < Page
    include LanguageProperties

    alias_method :template_orig, :template
    alias_method :url_placeholders_orig, :url_placeholders

    def template
      return "/:language" + template_orig if !language.nil?
      template_orig
    end

    def url_placeholders
      result = url_placeholders_orig.merge!({
        language: language,
        subset: subset
      })

      if !language.nil? && !subset.nil?
        @language_data ||= LanguagePlugin::LanguageData.new(@site, language)

        data = @language_data.get(subset)

        if !data.nil?
          filtered = data.reject{ |k, v| v.is_a?(Enumerable) }
          result.merge!(Hash[filtered.map{ |k, v| ["t.#{k}", v] }])
        end
      end

      result
    end
  end
end

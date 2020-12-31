module Services
  class Markdown
    class MarkdownRenderer < Redcarpet::Render::HTML
      ##################################################################################################################################
      # Modify the postprocess of redcarpet renderer to include our own markup
      ##################################################################################################################################
      def postprocess(text)
        text = display_icons(text)
        allowed_iframe(text)
      end

      ##################################################################################################################################
      # Images can be extended with image sizes
      ##################################################################################################################################
      def image(link, title, alt_text)
        case link
        when /^(.+?)\s*=+(\d+)(px|%)$/
          # e.g. ![alt](url.png =100px)
          # e.g. ![alt](url.png =100)
          %(<img src="#{Regexp.last_match(1)}" style="width: #{Regexp.last_match(2)}#{Regexp.last_match(3)}" alt="#{alt_text}" class="md-image">)
        when /^(.+?)\s*=+(\d+)(px|%)\s*x\s*(\d+)(px|%)$/
          # e.g. ![alt](url.png =30x50)
          %(<img src="#{Regexp.last_match(1)}" style="width: #{Regexp.last_match(2)}#{Regexp.last_match(3)}; height: #{Regexp.last_match(4)}#{Regexp.last_match(5)};" alt="#{alt_text}" class="md-image">)
        else
          %(<img src="#{link}" title="#{title}" alt="#{alt_text}" class="md-image">)
        end
      end

      ##################################################################################################################################
      # Replace {{xyz}} with the font-awesome icon with name xyz
      ##################################################################################################################################
      def display_icons(text)
        text.gsub(/{{([^})]*)}}/) do
          "<i class='fa fa-#{Regexp.last_match(1)}'></i>"
        end
      end

      ##################################################################################################################################
      # Replace {iframe}[link] with an iframe containing a youtube video or google maps snippet. Only those pages are allowed!
      ##################################################################################################################################
      def allowed_iframe(text)
        text.gsub(/\{iframe\}\(([^})]*)\)/) do
          link = Regexp.last_match(1)
          case link
          when %r{^https?://(www.|)youtube.com/watch\?v=(.*)\b}
            "<div class='responsive-iframe'>
                          <iframe src='https://www.youtube.com/embed/#{Regexp.last_match(2)}' allowfullscreen></iframe>
                      </div>"
          when %r{^https?://(www.|)youtube.com/embed/(.)\b}
            "<div class='responsive-iframe'>
                          <iframe src='https://www.youtube.com/embed/#{Regexp.last_match(2)}' allowfullscreen></iframe>
                      </div>"
          when %r{^https?://(www.|)google.(ch|com|de)/maps/d/embed\?mid=(.*)\b}
            "<div class='responsive-iframe'>
                          <iframe src='https://www.google.com/maps/d/embed?mid=#{Regexp.last_match(3)}'></iframe>
                      </div>"
          when %r{^https?://(www.|)google.(ch|com|de)/maps/embed\?pb=(.*)}
            "<div class='responsive-iframe'>
                          <iframe src=https://www.google.com/maps/embed?pb=#{Regexp.last_match(3)}' allowfullscreen></iframe>
                      </div>"
          end
        end
      end
    end

    def self.renderer
      @renderer ||= begin
        options = {
          filter_html:         true,
          hard_wrap:           true,
          link_attributes:     { rel: 'nofollow', target: '_blank' },
          space_after_headers: true
        }

        extensions = {
          superscript:                  true,
          disable_indented_code_blocks: true,
          tables:                       true,
          fenced_code_blocks:           true,
          strikethrough:                true,
          highlight:                    true
        }

        renderer = Services::Markdown::MarkdownRenderer.new(options)
        Redcarpet::Markdown.new(renderer, extensions)
      end
    end

    def self.render(text)
      renderer.render(text).html_safe
    end
  end
end

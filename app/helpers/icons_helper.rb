module IconsHelper
  def icon(name, tag: :i, classes: [])
    tag_classes = name
    tag_classes << classes
    content_tag tag, nil, class: tag_classes
  end
end

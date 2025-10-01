module ApplicationHelper
  def default_meta_tags
    {
      charset: "utf-8",
      description: "Tatoeは普段接点のない趣味や文化、職業などを、ユーザー同士で“例え”を使って共感を生むアプリです。「知ってほしい趣味、文化、職業」をお題として登録し、それに対して他のユーザーが「自分の得意分野」で例えていく、ユーザー参加型例え大喜利アプリになります。",
      canonical: request.original_url,
      og: {
        title: page_title,
        description: "Tatoeは普段接点のない趣味や文化、職業などを、ユーザー同士で“例え”を使って共感を生むアプリです。",
        type: "website",
        image: image_url("Tatoe_OGP.png"),
        url: request.original_url,
        locale: "ja-JP"
      },
      twitter: {
        card: "summary_large_image",
        site: "@nobu1362622"
      }
    }
  end

  def page_title(title = "")
    base_title = "Tatoe - 例えでつながる共感アプリ"
    title.present? ? "#{title} | #{base_title}" : base_title
  end
end

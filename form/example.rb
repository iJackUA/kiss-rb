module Kiss
  class Form


  end
end


class CreatePostForm < Kiss::Form
  attributes do
    attr :body { coerce(String).default('No text') }

    validate :body, required: true, nullable: false
  end

end

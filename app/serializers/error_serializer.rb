class ErrorSerializer
  def self.error_json(error)
    {
      errors: [
        {
          title: error.message,
          status: '404'
        }
      ]
    }
  end
end

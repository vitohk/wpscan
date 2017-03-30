# encoding: UTF-8

class WpItems < Array
  module Output

    def output(verbose = false, json_report = nil)
      self.each { |item| item.output(verbose, json_report) }
    end

  end
end

# encoding: UTF-8

class Vulnerabilities < Array
  module Output

    def output(verbose = false, json_report = nil)
      self.each do |v|
        v.output(verbose, json_report)
      end
    end

  end
end

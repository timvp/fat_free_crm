# Copyright (c) 2008-2013 Michael Dvorkin and contributors.
#
# Fat Free CRM is freely distributable under the terms of MIT license.
# See MIT-LICENSE file or http://www.opensource.org/licenses/mit-license.php
#------------------------------------------------------------------------------
module FatFreeCRM
  class Tabs
    cattr_accessor :main
    cattr_accessor :admin
    cattr_accessor :trainer

    # Class methods.
    #----------------------------------------------------------------------------
    class << self
      def main
        @@main ||= (Setting[:tabs] && Setting[:tabs].dup)
      end

      def admin
        @@admin ||= (Setting[:admin_tabs] && Setting[:admin_tabs].dup)
      end
      def trainer
        @@trainer ||= (Setting[:tabs_trainer] && Setting[:tabs_trainer].dup)
      end

    end
  end
end

module LianjifenClient
  class LianjifenOperateService < LianjifenBaseService
    attr_accessor :user, :lianjifen_service

    def initialize(user: nil)
      @user = user
      @points_symbol = LianjifenClient.config["lianjifen_points"]["symbol"]
      @lianjifen_service = LianjifenService.new
    end

    def add_points(amount: 0, is_async: true, mark: "")
      oper_result = @lianjifen_service.merchant_transfor(@points_symbol, @user.phone, amount, mark)
      return oper_result.nil? ? false : true
    end

    def reduce_points(amount: 0, is_async: true, mark: "")
      oper_result = @lianjifen_service.merchant_consume(@user.phone, amount, mark)
      return oper_result.nil? ? false : true
    end
  end
end

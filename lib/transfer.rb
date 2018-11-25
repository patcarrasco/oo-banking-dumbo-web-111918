class Transfer
  # your code here
  attr_reader :sender, :receiver, :amount
  attr_accessor :status

  def initialize(sender, receiver, amount)
    @sender = sender
    @receiver = receiver
    @status = "pending"
    @amount = amount
  end

  def valid?
    sender.valid? && receiver.valid?
  end

  def execute_transaction
    if valid? && status == "pending" && green?(amount)
      transfer_process
      self.status = "complete"
    else
      self.status = "rejected"
      "Transaction rejected. Please check your account balance."
    end
  end

  def reverse_transfer
    if status == "complete" && reverse_green?(amount)
      reverse_process
      self.status = "reversed"
    else
      "Reverse transaction rejected. Please check your account balance."
    end
  end

  private

  def green?(amt)
    sender_end_bal = self.sender.balance - amt
    sender_end_bal > 0
  end

  def reverse_green?(amt)
    receiver_end_bal = self.receiver.balance - amt
    receiver_end_bal > 0
  end

  def reverse_process
    self.sender.deposit(self.amount)
    self.receiver.withdraw(self.amount)
  end

  def transfer_process
    self.sender.withdraw(self.amount)
    self.receiver.deposit(self.amount)
  end
end

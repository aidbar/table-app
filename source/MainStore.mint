store MainStore {
    state passwordInput : String = ""
    state chosenWalletObj : UiWalletObject = { name ="", address = "", id = "" } 

    fun authenticationCancelled {
    sequence {
      passwordInput =
        ""

      Ui.Notifications.notifyDefault(<{ "Wallet authentication cancelled" }>)
    }
  }

  fun onChangePasswordInput (value : String) {
    sequence {
      next { passwordInput = value }
      Debug.log("value is " + value + ", passwordInput is " + passwordInput)
      next { }
    }
  }

  fun setChosenWallet(wallet : UiWalletObject) {
    next {chosenWalletObj = wallet}
  }
}
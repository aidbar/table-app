record UiWalletObject {
  name : String,
  address : String,
  id : String
}

component Main {
  state passwordInput : String = ""

  state array : Array(UiWalletObject) =
    [
      {
        name = "name1",
        address = "address1",
        id = "id1"
      }, {
        name = "name2",
        address = "address2",
        id = "id2"
      }
    ]

  fun rows (assets : Array(UiWalletObject)) {
    for (asset of assets) {
      {
        asset.name, [
          Ui.Cell::String(asset.name),
          Ui.Cell::String(asset.address),
          Ui.Cell::Html(actionRow(asset))
        ]
      }
    }
  }

  fun walletChosen (wallet : UiWalletObject) {
    sequence {
      content =
        <Ui.Modal.Content
          title=<{ "Wallet authentification" }>
          icon={Ui.Icons:INFINITY}
          content=<{
            <Ui.Content>
              <p>"Password for #{wallet.name}:"</p>
            </Ui.Content>

            <Ui.Input
              placeholder="Enter password"
              onChange={(value : String) { onChangePasswordInput(value) }}
              value={passwordInput}
              type="password"/>

            <p/>

            <Ui.Button
              label="Forgot password for this wallet?"
              size={Ui.Size::Px(10)}
              type="faded"
              onClick={(e : Html.Event) { forgotWalletPassword(wallet.id) }}/>
          }>
          actions=<{
            <Ui.Button
              onClick={(event : Html.Event) { Ui.Modal.cancel() }}
              label="Cancel"
              type="faded"/>

            <Ui.Button
              onClick={
                (event : Html.Event) {
                  sequence {
                    walletPasswordCheck(wallet)
                    next { }
                  }
                }
              }
              label="Authenticate"/>
          }>/>

      Ui.Modal.show(content)
      Ui.Notifications.notifyDefault(<{ "Wallet authentication started" }>)
    } catch {
      authenticationCancelled()
    }
  }

  fun walletPasswordCheck (wallet : UiWalletObject) {
    next { }

    /*
    sequence {
            encryptedWalletJson = Json.parse(wallet.wallet) |> Maybe.toResult("Json parsing error")
            encryptedWallet = decode encryptedWalletJson as EncryptedWallet
            decryptedWallet = Axentro.Wallet.decryptWallet(encryptedWallet, passwordInput)
            Result.ok(decryptedWallet)
          } catch Object.Error => er {
            Result.error(er)
          } catch String => er {
            Result.error(er)
          } catch Wallet.Error => er {
            Result.error(er)
          }
    */
  }

  fun forgotWalletPassword (walletId : String) {
    next { }
  }

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

  fun actionRow (wallet : UiWalletObject) {
    <div>
      <Ui.Grid
        mobileWidth={Ui.Size::Px(50)}
        width={Ui.Size::Px(50)}
        gap={Ui.Size::Px(20)}>

        <Ui.Button
          iconBefore={<></>}
          size={Ui.Size::Px(10)}
          label="CHOOSE"
          onClick={(e : Html.Event) { walletChosen(wallet) }}
          type="secondary"/>

      </Ui.Grid>
    </div>
  }

  fun render : Html {
    <div>
      <Ui.Table
        size={Ui.Size::Px(16)}
        bordered={true}
        orderDirection="desc"
        orderBy="name"
        breakpoint={0}
        headers=[
          {
            sortKey = "name",
            sortable = true,
            label = "Name",
            shrink = false
          },
          {
            sortKey = "balance",
            sortable = false,
            label = "Address",
            shrink = false
          },
          {
            sortKey = "actions",
            sortable = false,
            label = "Actions",
            shrink = false
          }
        ]
        rows={rows(array)}

        />
    </div>
  }
}
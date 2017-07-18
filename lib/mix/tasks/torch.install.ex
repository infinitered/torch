defmodule Mix.Tasks.Torch.Install do
  @moduledoc """
  Installs all the files Torch needs to run within the context of your Phoenix
  application. Specifically, it generates the following files:

  ```
  web/templates/layout/admin.html.{format}
  web/static/css/_admin_variables.scss
  ```

  ## Parameters

  - **Format**: Either 'eex' or 'slim'.

  ## Example

      mix torch.install eex
      mix torch.install slim
  """

  use Mix.Task

  @doc false
  def run([format]) do
    Mix.Torch.copy_from [:torch], "priv/templates/#{format}", "", [], [
      {:eex, "layout.#{format}.eex", "web/templates/layout/admin.html.#{format}"}
    ]

    Mix.Torch.copy_from [:torch], "priv/templates/sass", "", [], [
      {:text, "_variables.scss", "web/static/css/_admin_variables.scss"}
    ]

    Mix.shell.info """
    #{hr()}
                                   #{IO.ANSI.yellow}TORCH INSTALLED!#{IO.ANSI.reset}
    #{hr()}

    There are three final steps you must complete manually:

    1. Import the CSS styles. If you want to use the SASS styles, you should
       update your app.scss file to look like this:

        @import "admin_variables";
        @import "~torch/assets/css/app";

    2. Configure your asset builder to include node_modules

      Using Brunch? Checkout the Brunch guide: http://github.com/infinitered/torch/docs/guides/brunch.md
      Using webpack? Checkout the webpack guide: http://github.com/infinitered/torch/docs/guides/webpack.md

    3. Import the Javascript in your `app.js` file. Requires that your `package.json`
       has been updated as described in the README.

        import 'torch'

    4. Add an admin scope to your router in `router.ex`:

        scope "/admin", #{Mix.Torch.base}.Admin, as: :admin do
          pipe_through :browser
        end

    With those steps complete, you can generate admin controllers with `torch.gen.html`.
    """
  end

  defp hr do
    for _ <- 1..80, into: "", do: "\u{1F525}"
  end
end

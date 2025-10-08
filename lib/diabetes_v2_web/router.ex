defmodule DiabetesV2Web.Router do
  use DiabetesV2Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DiabetesV2Web.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DiabetesV2Web do
    pipe_through :browser

    live_session :default, on_mount: DiabetesV2Web.LiveUserAuth do
      # Add this as the home page
      live "/", DashboardLive, :index
      live "/product_main_types", ProductMainTypeLive.Index, :index
      live "/product_main_types/new", ProductMainTypeLive.Form, :new
      live "/product_main_types/:id/edit", ProductMainTypeLive.Form, :edit
      live "/product_main_types/:id", ProductMainTypeLive.Show, :show
      live "/product_main_types/:id/show/edit", ProductMainTypeLive.Show, :edit

      live "/product_sub_types", ProductSubTypeLive.Index, :index
      live "/product_sub_types/new", ProductSubTypeLive.Form, :new
      live "/product_sub_types/:id/edit", ProductSubTypeLive.Form, :edit
      live "/product_sub_types/:id", ProductSubTypeLive.Show, :show
      live "/product_sub_types/:id/show/edit", ProductSubTypeLive.Show, :edit

      live "/product_categories", ProductCategoryLive.Index, :index
      live "/product_categories/new", ProductCategoryLive.Form, :new
      live "/product_categories/:id/edit", ProductCategoryLive.Form, :edit
      live "/product_categories/:id", ProductCategoryLive.Show, :show
      live "/product_categories/:id/show/edit", ProductCategoryLive.Show, :edit

      live "/products", ProductLive.Index, :index
      live "/products/new", ProductLive.Form, :new
      live "/products/:id/edit", ProductLive.Form, :edit
      live "/products/:id", ProductLive.Show, :show
      live "/products/:id/show/edit", ProductLive.Show, :edit

      live "/product_aliases", ProductAliasLive.Index, :index
      live "/product_aliases/new", ProductAliasLive.Form, :new
      live "/product_aliases/:id/edit", ProductAliasLive.Form, :edit
      live "/product_aliases/:id", ProductAliasLive.Show, :show
      live "/product_aliases/:id/show/edit", ProductAliasLive.Show, :edit
      # get "/", PageController, :home
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", DiabetesV2Web do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:diabetes_v2, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: DiabetesV2Web.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

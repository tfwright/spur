defmodule Spur.MixProject do
  use Mix.Project

  def project do
    [
      app: :spur,
      description: "Activity tracking for Elixir apps",
      version: "0.3.1",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      source_url: "https://github.com/tfwright/spur",
      elixirc_paths: elixirc_paths(Mix.env()),
      name: "Spur",
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      env: [
        audience_assoc_name: :activities,
        expose_transactions: false
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:ecto, "~> 3.0"},
      {:ecto_sql, "~> 3.0", only: :test},
      {:postgrex, "~> 0.14", only: :test},
      {:jason, "~> 1.0", only: :test},
      {:atomic_map, "~> 0.9"}
    ]
  end

  defp package do
   %{
     name: :spur,
     files: ["lib", "mix.exs", "README*"],
     maintainers: [
       "T. Floyd Wright",
     ],
     licenses: ["Apache License 2.0"],
     links: %{
       "GitHub" => "https://github.com/tfwright/spur"
     }
   }
 end

 def docs do
   [main: "Spur"]
 end

 defp elixirc_paths(:test), do: ["lib", "test/support"]
 defp elixirc_paths(_), do: ["lib"]
end

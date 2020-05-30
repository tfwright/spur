defmodule Spur.DeprecationCheck do
  defmacro __before_compile__(_env) do
    if Application.get_env(:spur, :audience_module) do
      IO.warn(
        "Configuring audience association via `audience_module` option is deprecated and will be removed in v0.5.0. Use `audience_association_options` instead."
      )
    end
  end
end

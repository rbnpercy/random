defmodule Luno.Handlers.V1.Events do
  @moduledoc """
    Request Handler for all User/Events related actions.  All to be re-written with Auth/DB.
  """
  
  @doc """
    Get the full list of Events for a specific user.
  """
  @spec get_user_events(String.t, integer) :: map
  def get_user_events(acc_id, user_id) do
    %{"account_id" => "#{acc_id}", "user_id" => "#{user_id}", "count" => 6911, "pages" => 62, "list" => "events_here"}
  end

  @doc """
    Create a User Event.  Return success map with Event id.
     ** Will need to Handle User_not_found in future.
  """
  @spec create_event(String.t, integer) :: map
  def create_event(acc_id, user_id) do
    %{"success" => true, "id" => 12342}
  end

  @doc """
    Get a User Event. - Will have to handle user_id and event_id errors in future.
  """
  @spec get_event(String.t, integer, integer) :: map
  def get_event(acc_id, user_id, event_id) do
    case event_id do
      "1234" ->
        %{"id" => 1234, "user_id" => "#{user_id}", "event_name" => "used_product", "event_details" => "User Used Product..."}
      _ ->
        false
    end
  end

end
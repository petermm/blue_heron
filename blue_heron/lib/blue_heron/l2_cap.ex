defmodule BlueHeron.L2Cap do
  defstruct [:data, :cid]

  def deserialize(<<length::little-16, cid::little-16, data::binary-size(length)>>) do
    case cid do
      # L2CAP Signaling
      0x1 ->
        BlueHeron.L2Cap.Signaling.deserialize(%__MODULE__{cid: cid}, data)

      # att
      0x4 ->
        BlueHeron.ATT.deserialize(%__MODULE__{cid: cid}, data)

      # L2CAP Signaling
      0x5 ->
        BlueHeron.L2Cap.Signaling.deserialize(%__MODULE__{cid: cid}, data)

      _ ->
        %__MODULE__{
          cid: cid,
          data: data
        }
    end
  end

  def serialize(%__MODULE__{data: %type{} = data} = l2cap) do
    serialize(%{l2cap | data: type.serialize(data)})
  end

  def serialize(%__MODULE__{cid: cid, data: data}) do
    length = byte_size(data)
    <<length::little-16, cid::little-16, data::binary-size(length)>>
  end
end

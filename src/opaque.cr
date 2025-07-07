class Mujs::Opaque(T)
  def self.box(js, object : T) : UInt64
    hash = object.hash
    js.opaque[hash] = Box(T).box(object)
    hash
  end

  def self.unbox(js, hash : Mujs::DefnReturn) : T
    hash = hash.as(Float64)
    val = Box(T).unbox(js.opaque[hash])
    js.opaque.delete(hash)
    val
  end
end

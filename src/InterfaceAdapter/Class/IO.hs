module InterfaceAdapter.Class.IO
  ( AnonEff,
    EffName,
    HasEff,
    NamedEff,
    lift,
  )
where

import Data.Extensible
import Data.Extensible.Effect
import Data.Proxy (Proxy (Proxy))
import Essential hiding (lift)

type EffName = "IO"

type AnonEff = IO

type NamedEff = EffName >: AnonEff

type HasEff effs = Lookup effs EffName IO

lift :: forall effs a. HasEff effs => IO a -> Eff effs a
lift = liftEff (Proxy @EffName)

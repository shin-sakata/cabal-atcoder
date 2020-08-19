module Effect.Adapter.IO
  ( AnonEff,
    EffName,
    HasEff,
    NamedEff,
    lift,
  )
where

import Essential

type EffName = "IO"

type AnonEff = IO

type NamedEff = EffName >: AnonEff

type HasEff effs = Lookup effs EffName IO

lift :: forall effs a. HasEff effs => IO a -> Eff effs a
lift = liftEff (Proxy @EffName)

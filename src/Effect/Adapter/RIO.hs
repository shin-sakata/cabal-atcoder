{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE UndecidableInstances #-}

module Effect.Adapter.RIO
  ( AnonEff,
    EffName,
    HasEff,
    NamedEff,
    lift,
  )
where

import Essential

type EffName = "IO"

type AnonEff = RIO

type NamedEff env = EffName >: AnonEff env

type HasEff env effs = Lookup effs EffName (RIO env)

lift :: forall env effs a. HasEff env effs => RIO env a -> Eff effs a
lift = liftEff (Proxy @EffName)

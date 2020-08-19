-- Localに作成されたProjectディレクトリ等の操作を行うEffect
module Effect.Adapter.Project
  ( AnonEff,
    EffName,
    HasEff,
    NamedEff,
    lift,
    createProject,
    Project (..),
  )
where

import Essential
import Domain.Object.Contest (Contest)

data Project a where
  CreateProject :: Contest -> Project ()

type EffName = "Project"

type AnonEff = Project

type NamedEff = EffName >: AnonEff

type HasEff effs = Lookup effs EffName Project

lift :: forall effs a. HasEff effs => Project a -> Eff effs a
lift = liftEff (Proxy @EffName)

createProject :: HasEff effs => Contest -> Eff effs ()
createProject contest = lift (CreateProject contest)

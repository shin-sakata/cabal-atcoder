-- Localに作成されたProjectディレクトリ等の操作を行うEffect
module Effect.Adapter.Project
  ( AnonEff,
    EffName,
    HasEff,
    NamedEff,
    lift,
    buildProject,
    writeProject,
    Project (..),
  )
where

import Essential
import Domain.Object.Contest (Contest)
import qualified Domain.Object.Project as Obj

data Project a where
  BuildProject :: Contest -> Project Obj.Project
  WriteProject :: Obj.Project -> Project ()

type EffName = "Project"

type AnonEff = Project

type NamedEff = EffName >: AnonEff

type HasEff effs = Lookup effs EffName Project

lift :: forall effs a. HasEff effs => Project a -> Eff effs a
lift = liftEff (Proxy @EffName)

buildProject :: HasEff effs => Contest -> Eff effs Obj.Project
buildProject contest = lift (BuildProject contest)

writeProject :: HasEff effs => Obj.Project -> Eff effs ()
writeProject project = lift (WriteProject project)

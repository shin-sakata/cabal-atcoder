module Usecase.CreateProject where

import DomainObject.Contest (Contest, ContestId)
import qualified Effect.Adapter.AtCoder as AtCoder
import qualified Effect.Adapter.SessionRepository as SessionRepository
import qualified Effect.Adapter.Project as Project
import Usecase.Imports

createProject ::
  ( AtCoder.HasEff effs,
    SessionRepository.HasEff effs,
    Project.HasEff effs
  ) =>
  ContestId ->
  Eff effs ()
createProject contestId = do
  session <- SessionRepository.get
  contest <- AtCoder.getContest contestId
  Project.createProject contest

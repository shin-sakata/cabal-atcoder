module Effect.Handler.SessionRepository.File (run) where

import qualified Effect.Adapter.RIO as RIO
import Effect.Adapter.SessionRepository (SessionRepository (..))
import qualified Effect.Adapter.SessionRepository as SessionRepository
import qualified Effect.Handler.SessionRepository.File.Config as Config
import Essential
import System.Directory
  ( XdgDirectory (XdgCache),
    createDirectory,
    doesDirectoryExist,
    getXdgDirectory,
  )
import System.Environment (getEnv)
import Text.Read (readMaybe)

run ::
  forall env effs a.
  Config.HasSessionPath env =>
  RIO.HasEff env effs =>
  Eff (SessionRepository.NamedEff ': effs) a ->
  Eff effs a
run effs = peelEff0 pure interpret effs
  where
    interpret ::
      forall r.
      SessionRepository.AnonEff r ->
      (r -> Eff effs a) ->
      Eff effs a
    interpret Remove k = do
      RIO.lift removeSession
      k ()
    interpret Get k = do
      session <- RIO.lift getSession
      k session
    interpret (Store session) k = do
      RIO.lift $ storeSession session
      k ()

removeSession :: Config.HasSessionPath env => RIO env ()
removeSession = storeSession mempty

storeSession ::
  Config.HasSessionPath env =>
  SessionRepository.Session ->
  RIO env ()
storeSession session = do
  sessionPath <- view Config.sessionPathL
  writeFileUtf8 sessionPath $ convertString $ show session

getSession ::
  Config.HasSessionPath env =>
  RIO env SessionRepository.Session
getSession = do
  sessionPath <- view Config.sessionPathL
  sessionUtf8 <- readFileUtf8 sessionPath
  case readMaybe $ convertString sessionUtf8 of
    Just session -> pure session
    Nothing -> throwString "The session file is corrupted."

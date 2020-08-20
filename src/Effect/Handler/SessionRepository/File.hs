module Effect.Handler.SessionRepository.File (run) where

import qualified Effect.Adapter.RIO as RIO
import Effect.Adapter.SessionRepository (SessionRepository (..))
import qualified Effect.Adapter.SessionRepository as SessionRepository
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
  RIO.HasEff env effs =>
  Eff (SessionRepository.NamedEff ': effs) a ->
  Eff effs a
run effs = peelEff0 pure interpret effs
  where
    interpret :: forall r. SessionRepository.AnonEff r -> (r -> Eff effs a) -> Eff effs a
    interpret Remove k = do
      RIO.lift removeSession
      k ()
    interpret Get k = do
      session <- RIO.lift getSession
      k session
    interpret (Store session) k = do
      RIO.lift $ storeSession session
      k ()

removeSession :: RIO env ()
removeSession = storeSession mempty

storeSession :: SessionRepository.Session -> RIO env ()
storeSession session = do
  sessionPath <- liftIO $ getSessionPath
  writeFileUtf8 sessionPath $ convertString $ show session

getSession :: RIO env SessionRepository.Session
getSession = do
  sessionPath <- liftIO $ getSessionPath
  sessionUtf8 <- readFileUtf8 sessionPath
  case readMaybe $ convertString sessionUtf8 of
    Just session -> pure session
    Nothing -> throwString "The session file is corrupted."

getSessionPath :: IO FilePath
getSessionPath = do
  let sessionFileName = "session"
  cacheDir <- getCacheDir
  initDir cacheDir
  pure $ cacheDir </> sessionFileName
  where

initDir :: FilePath -> IO ()
initDir dir = do
  exists <- doesDirectoryExist dir
  if exists
    then pure ()
    else createDirectory dir

getCacheDir :: IO FilePath
getCacheDir = do
  cacheDir <- getEnv "CABAL_ATCODER_TEST_CACHE_DIR"
  if null cacheDir
    then getXdgDirectory XdgCache "cabal-atcoder"
    else pure cacheDir

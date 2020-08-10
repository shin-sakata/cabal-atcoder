module Effect.Handler.SessionRepository.File (run) where

import Data.Extensible.Effect
import qualified Effect.Adapter.IO as IO
import Effect.Adapter.SessionRepository (SessionRepository (..))
import qualified Effect.Adapter.SessionRepository as SessionRepository
import Essential hiding (lift)
import System.Directory
  ( XdgDirectory (XdgCache),
    createDirectory,
    doesDirectoryExist,
    getXdgDirectory,
  )
import System.Environment (getEnv)
import System.FilePath ((</>))
import Text.Read (readMaybe)

run ::
  forall effs a.
  IO.HasEff effs =>
  Eff (SessionRepository.NamedEff ': effs) a ->
  Eff effs a
run effs = peelEff0 pure interpret effs
  where
    interpret :: forall r. SessionRepository.AnonEff r -> (r -> Eff effs a) -> Eff effs a
    interpret Remove k = do
      IO.lift removeSession
      k ()
    interpret Get k = do
      session <- IO.lift getSession
      k session
    interpret (Store session) k = do
      IO.lift $ storeSession session
      k ()

removeSession :: IO ()
removeSession = storeSession mempty

storeSession :: SessionRepository.Session -> IO ()
storeSession session = do
  sessionPath <- getSessionPath
  writeFile sessionPath $ show session

getSession :: IO SessionRepository.Session
getSession = do
  sessionPath <- getSessionPath
  sessionUtf8 <- readFile sessionPath
  case readMaybe $ sessionUtf8 of
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

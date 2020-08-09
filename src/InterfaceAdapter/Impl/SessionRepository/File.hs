module InterfaceAdapter.Impl.SessionRepository.File where

import Data.Extensible.Effect
import Essential hiding (lift)
import qualified InterfaceAdapter.Class.IO as IO
import InterfaceAdapter.Class.SessionRepository (SessionRepository (..))
import qualified InterfaceAdapter.Class.SessionRepository as SessionRepository
import qualified RIO.Text as T

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

sessionPath :: FilePath
sessionPath = "session"

removeSession :: IO ()
removeSession = storeSession mempty

storeSession :: SessionRepository.Session -> IO ()
storeSession = writeFileUtf8 sessionPath . T.pack . show

getSession :: IO SessionRepository.Session
getSession = do
  sessionUtf8 <- readFileUtf8 sessionPath
  case readMaybe $ T.unpack sessionUtf8 of
    Just session -> pure session
    Nothing -> throwString "The session file is corrupted."
